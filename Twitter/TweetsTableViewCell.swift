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
    @IBOutlet weak var time: UILabel!

    @IBOutlet weak var tweetContentText: UILabel!
    
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var likesCount: UILabel!
    
    
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
            retweetCount.text = String(tweet.retweetCount!)
            likesCount.text = String(tweet.likeCount!)
            tweetID = tweet.id
            retweetCount.text! == "0" ? (retweetCount.hidden = true) : (retweetCount.hidden = false)
            likesCount.text! == "0" ? (likesCount.hidden = true) : (likesCount.hidden = false)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
