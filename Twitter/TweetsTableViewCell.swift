//
//  TweetsTableViewCell.swift
//  Twitter
//
//  Created by JP on 2/19/16.
//  Copyright © 2016 tpham44. All rights reserved.
//

import UIKit

class TweetsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    
    @IBOutlet weak var tweetContentText: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var RetweetButton: UIButton!
    @IBOutlet weak var LikeButton: UIButton!
    @IBOutlet weak var RetweetCountLabel: UILabel!
    @IBOutlet weak var LikesCountLabel: UILabel!
    
    var islikeButton: Bool = false  //set to false
    var isRetweetButton: Bool = false //
    
    var tweetID: String = ""
    var tweet: Tweet! {
        didSet {
            tweetContentText.text = tweet.text
            userName.text = "\((tweet.user?.name)!)"
            userHandle.text = "@\(tweet.user!.screenname!)"
            if (tweet.user?.profileImageUrl != nil){
                let imageUrl = tweet.user?.profileImageUrl!
                profileImage.setImageWithURL(NSURL(string: imageUrl!)!)
            } else{
                print("No profile image found")
            }
            RetweetCountLabel.text = String(tweet.retweetCount!)
            LikesCountLabel.text = String(tweet.likeCount!)
            tweetID = tweet.id
            RetweetCountLabel.text! == "0" ? (RetweetCountLabel.hidden = true) : (RetweetCountLabel.hidden = false)
            LikesCountLabel.text! == "0" ? (LikesCountLabel.hidden = true) : (LikesCountLabel.hidden = false)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userName.preferredMaxLayoutWidth = userName.frame.size.width
        profileImage.layer.cornerRadius = 4
        profileImage.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userName.preferredMaxLayoutWidth = userName.frame.size.width
    }
    
    
    
    
    
    @IBAction func OnTweet(sender: AnyObject) {
        
        TwitterClient.sharedInstance.retweet(Int(tweetID)!, params: nil, completion: { (error) -> () in
            //return boolean true or false from R isRetweetCountLabel
            
            if self.isRetweetButton {
                self.RetweetCountLabel.text = String(self.tweet.retweetCount!)
                self.RetweetButton.setImage(UIImage(named: "retweet-acction"), forState: UIControlState.Normal)
                self.isRetweetButton = false
                    self.tweet.retweetCount!--  /*decrement*/
                    self.RetweetCountLabel.textColor = UIColor.grayColor()
            
                if self.RetweetCountLabel.text == "0" {
                    self.RetweetCountLabel.hidden = true
                }
            
            
            } else {
            self.RetweetButton.setImage (UIImage(named: "retweet"), forState: UIControlState.Normal)
                self.isRetweetButton = true
                self.tweet.retweetCount!++ /*ncr*/
            //self.LikesCountLabel.hidden = false
                self.RetweetCountLabel.textColor = UIColor (red: 0.8471, green: 0.1608, blue: 0.2039, alpha: 1.0) /* #d82934 */
            
                if self.RetweetCountLabel.text == "0" {
                      self.RetweetCountLabel.hidden  = false
            }
        }

       
         self.RetweetCountLabel.text = "\(self.tweet.retweetCount!)"
    })

}


    // This function is not working messages said Coundn't retweet
    
    @IBAction func OnLike(sender: AnyObject) {
        TwitterClient.sharedInstance.likeTweet(Int(tweetID)!, params: nil, completion: {(error) -> () in
 
            if self.islikeButton {
                
                self.LikesCountLabel.text = String(self.tweet.likeCount!)
                //print(self.tweet.likeCount)
                self.LikeButton.setImage(UIImage(named: "like-action"), forState: UIControlState.Normal)
                
                self.islikeButton = false
                    self.tweet.likeCount!-- //dec
                    self.LikesCountLabel.textColor = UIColor.grayColor()
                
                if self.LikesCountLabel.text == "0" {
                    self.LikesCountLabel.hidden = true
                }
                
            } else {
                self.LikeButton.setImage(UIImage(named: "Like"), forState: UIControlState.Normal)
                self.islikeButton = true
                self.tweet.likeCount!++ //ncr
                //self.LikesCountLabel.hidden = false
                self.LikesCountLabel.textColor = UIColor(red: 0.8471, green: 0.1608, blue: 0.2039, alpha: 1.0) /* #d82934 */
                
                if self.LikesCountLabel.text == "0" {
                    self.LikesCountLabel.hidden = false
                }
            }
       
            self.LikesCountLabel.text = "\(self.tweet.likeCount!)"
        })
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}


