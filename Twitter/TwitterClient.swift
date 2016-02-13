//
//  TwitterClient.swift
//  Twitter
//
//  Created by JP on 2/11/16.
//  Copyright © 2016 tpham44. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "7J1brydUzTfjGwvzyRHgbup44"
let twitterConsumerSecret = "QWgmeGjwqIIGW6eHiHGyyDFXYauD61QUTNBVMh24RVHUGjYZRv"
let twitterBaseURL = NSURL(string:"https://api.twitter.com")


class TwitterClient: BDBOAuth1SessionManager {
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance =
            TwitterClient(baseURL: twitterBaseURL,
                consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
        
    }

}
