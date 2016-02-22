//
//  Tweet.swift
//  Twitter
//
//  Created by JP on 2/14/16.
//  Copyright © 2016 tpham44. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var Time: String!
    var PassedTime: Int?
    var retweetCount: Int?
    var id: String
    var likeCount: Int?

    
    
    init(dictionary: NSDictionary) {

        user = User ( dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        id = String(dictionary["id"]!)
    
        retweetCount = dictionary["retweet_count"] as? Int
        likeCount = dictionary["favorite_count"] as? Int
        let now = NSDate()
        
        let then = createdAt
        PassedTime = Int(now.timeIntervalSinceDate(then!))
        
        if PassedTime >= 86400{
            Time = String(PassedTime! / 86400)+"d"
        }
        if (3600..<86400).contains(PassedTime!){
            Time = String(PassedTime!/3600)+"h"
        }
        if (60..<3600).contains(PassedTime!){
            Time = String(PassedTime!/60)+"m"
        }
        if PassedTime < 60 {
            Time = String(PassedTime!)+"s"
        }

    
    }
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        //convenience method to give us an array of tweets
    
        
        return tweets
    }

}
