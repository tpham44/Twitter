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
  
    
    

    
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary ["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
        
    }
    func logout() {
        // clear user info and send notification that logout happened
        User.currentUser = nil
        // clear the access token
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        // send broadcast that the user logged out
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    // methods to store and restore current user
    
    
    class var currentUser: User?
        {
        
        get {
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
            if data != nil
            {
                do {
                    let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    _currentUser = User(dictionary: dictionary as! NSDictionary)
        //**************
                    } catch (let error) {
                        print(error)
                    }
            }
        }
        
        return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            if (_currentUser != nil) {
                do {
                    // if current user is not nil, change it to the JSON serialized string
                    let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: NSJSONWritingOptions.PrettyPrinted)
                    // store it in the key
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                    //  save (write or flush) it to disk
                    NSUserDefaults.standardUserDefaults().synchronize()
                } catch (let error) {
                    print(error)
                    }
                }else {
                    // even if it's nil you still want to clear it
                    NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
                }
                    NSUserDefaults.standardUserDefaults().synchronize()
                
            }
        }
   }
