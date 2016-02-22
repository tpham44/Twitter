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
        
        TwitterClient.sharedInstance.retweet(Int(tweetID)!, params: nil, completion: {(error) -> () in
            
            if self.RetweetCountLabel.text! > "0" {
                self.RetweetCountLabel.text = String(self.tweet.retweetCount! + 1)
            } else {
                self.RetweetCountLabel.hidden = false
                self.RetweetCountLabel.text = String(self.tweet.retweetCount! + 1)
            }
        })
    }
    
    
    
    @IBAction func OnLike(sender: AnyObject) {
        TwitterClient.sharedInstance.likeTweet(Int(tweetID)!, params: nil, completion: {(error) -> () in
            
            if self.LikesCountLabel.text! > "0" {
                self.LikesCountLabel.text = String(self.tweet.likeCount! + 1)
            } else {
                self.LikesCountLabel.hidden = false
                self.LikesCountLabel.text = String(self.tweet.likeCount! + 1)
            }
        })
        
    }
    
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
