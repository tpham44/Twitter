//
//  TwitterClient.swift
//  Twitter
//
//  Created by JP on 2/11/16.
//  Copyright © 2016 tpham44. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
//import AFNetworking

let twitterConsumerKey = "7J1brydUzTfjGwvzyRHgbup44"
let twitterConsumerSecret = "QWgmeGjwqIIGW6eHiHGyyDFXYauD61QUTNBVMh24RVHUGjYZRv"
let twitterBaseURL = NSURL(string:"https://api.twitter.com")



class TwitterClient: BDBOAuth1SessionManager {
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    class var sharedInstance: TwitterClient {
        struct Static{
            static let instance =  TwitterClient(baseURL: twitterBaseURL ,consumerKey: twitterConsumerKey , consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()){
        
        TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: params, success: {(operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            //print("home timeline: \(response)")}
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            for tweet in tweets {
                print("text: \(tweet.text), created: \(tweet.createdAt) ")
            }
            
            completion(tweets: tweets, error: nil)
            
            },failure: {(operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error getting home timeline")
                completion(tweets: nil, error: error)
        })
    }
    
    
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()){
        loginCompletion = completion
        
        //Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitter://oauth"), scope: nil, success: {(requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            })
            { (error: NSError!) ->Void in
                print("Error gettin the request token: \(error)")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    
    
    func openURL(url: NSURL){
        
        fetchAccessTokenWithPath(
            "oauth/access_token",
            method: "POST",
            requestToken: BDBOAuth1Credential(queryString: url.query),
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                print("Got the access token!")
                
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                TwitterClient.sharedInstance.GET( "1.1/account/verify_credentials.json", parameters: nil, success: { (operation:NSURLSessionDataTask!, response: AnyObject?) -> Void in
                        //print("user: \(response!)")
                        
                        let user = User(dictionary: response as! NSDictionary)
                        
                        User.currentUser = user
                        
                        print("user: \(user.name)")
                        self.loginCompletion?(user: user, error: nil)
                        
                    }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                        print("error getting current user")
                        self.loginCompletion?(user: nil, error: error)
                })
            }, failure: { (error: NSError!) -> Void in
                print("Fail to receive access token")
                self.loginCompletion?(user: nil, error: error)
        })
    }
    
    //Add favorite to the twitterClient to extract it from Dictionary
    
    
    
    func retweet(id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
        POST("1.1/statuses/retweet/\(id).json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("Retweeted tweet with id: \(id)")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Couldn't retweet")
                completion(error: error)
            }
        )
    }
    

    
    func likeTweet (id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
        POST("1.1/favorites/create.json?id=\(id)", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("faved tweet with id: \(id)")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Couldn't fav tweet")
                completion(error: error)
            }
        )}
    
    
    //reply status
    func postTweet(tweet: String, replyId: Int?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        
        var params = ["status": tweet]
        if replyId != nil {
            params["in_reply_to_status_id"] = String(replyId!)
        }
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error)
                completion(tweet: nil, error: error)
        }
    }
    
    
    func getProfileBanner(id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
        GET("1.1/users/profile_banner.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("got user banner")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("did not get user banner")
                completion(error: error)
            }
        )
    }
    
    
    func getUserTimeline(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        
        GET("1.1/statuses/user_timeline.json", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweet = Tweet.tweetAsDictionary(response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                completion(tweet: nil, error: error)
        }
    }
}

/*
class TwitterClient: BDBOAuth1SessionManager {
    
    var loginWithCompletion: ((user: User?, error: NSError?) -> ())?

    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance =
            TwitterClient(baseURL: twitterBaseURL,
                consumerKey:twitterConsumerKey,
                consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    
    func homeTimelineWithParams (params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET( "1.1/statuses/home_timeline.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            //print("home_timeline: \(response!)"), Minute 10:15 second video -- testing something out?; More checking to see if the code works so far
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error getting home TimeLine")
                completion(tweets: nil, error: error)
        })
    }
    
    func retweet(id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
        POST("1.1/statuses/retweet/\(id).json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("Retweeted tweet with id: \(id)")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Couldn't retweet")
                completion(error: error)
            }
        )
    }

    
    
    func openURL(url: NSURL){
        // Called when someone tries to redirect the User via URL
        // Steps: access the Twitter singleton

            fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print ("Got the access token in openURL!")
            
            // save the access token in the Twitter Client
                
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                
                let user = User(dictionary: response as! NSDictionary)
                
                User.currentUser = user // this should persist the user as current user
                print("This print the  current user ")
                print("user: \(user.name)")
                self.loginWithCompletion?(user: user, error: nil)
                }, failure: { (operation:NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("error: \(error)")
                    self.loginWithCompletion?(user: nil, error: error)
                })
                
                }) {(error: NSError!) -> Void in
                print("Failed to receive access token")
                self.loginWithCompletion?(user: nil, error: error)
        }
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()){
        loginWithCompletion = completion
        
        //clear cache because the base class caches tokens
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        
        // Step 1: Get Request Token. The request token gives permission to send the user to the Twitter authentication mobile page
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "cptwitter://oauth"),
            scope: nil,
            success: { (requestToken:BDBOAuth1Credential!) -> Void in
                
                print("Got the request token in completion")
                
                // Step 2: Authorize URL.  Once you have the token you can create the authURL
                
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                
                print("I got authorize oauth token ")
                UIApplication.sharedApplication().openURL(authURL!)
                
            }) { (error: NSError!) -> Void in
                print("Failed to get request token: \(error)")
                self.loginWithCompletion?(user: nil, error: error)
        }
    }
    

    
    func likeTweet(id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){ POST("1.1/favorites/create.json?id=\(id)", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("Liked tweet with id: \(id)")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Couldn't like tweet")
                completion(error: error)
            }
        )}


}
*/
