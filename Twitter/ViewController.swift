//
//  ViewController.swift
//  Twitter
//
//  Created by JP on 2/11/16.
//  Copyright © 2016 tpham44. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
//import BDBOAuth1Credential


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources Bthat can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {
        // access to twitterClient
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        // first step get request token
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath(
            "oauth/request_token",
            method: "GET", callbackURL: NSURL(string: "cputwitterdemo://oauth"),
            scope: nil,
            success:{
                (requestToken: BDBOAuth1Credential!) -> Void in
                    print ("Got request token ViewController swift") // got token back will allow me to send a user to that twitter to authentication mobil page.
            
            //Build authentication URL since I got the token
            let authURL = NSURL(string:"https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                
            UIApplication.sharedApplication().openURL(authURL!)
            
        }) { (error: NSError!) -> Void in
                print("failt to get token")
            
        }
    }
}