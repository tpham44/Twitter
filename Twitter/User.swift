//
//  User.swift
//  Twitter
//
//  Created by JP on 2/14/16.
//  Copyright © 2016 tpham44. All rights reserved.
//
import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary
    var profileBannerURL: String?
    var location: String?
    var follower: Int?
    var following: Int?
    var myID: Int?  //meID
    var tweetcount: Int?
    
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        myID = dictionary["id"] as? Int
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
        
//         profileBannerURL = dictionary["profile_banner_url"] as? String
        
        if dictionary["profile_banner_url"] != nil {
           profileBannerURL = (dictionary["profile_banner_url"] as? String)!
        }

        
        location = dictionary["location"] as? String
        follower = dictionary["followers_count"] as? Int
        following = dictionary["friends_count"] as? Int
        tagline = dictionary["description"] as? String
        tweetcount = dictionary["statuses_count"] as? Int

    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
        if _currentUser == nil {
        let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
        if data != nil {
        do {
        let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
        _currentUser = User(dictionary: dictionary as! NSDictionary)
    } catch _ {
        
        }
        }
        }
        return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                do {
                    let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: NSJSONWritingOptions())
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                } catch _ {
                    
                }
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
