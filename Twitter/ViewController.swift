//
//  ViewController.swift
//  Twitter
//
//  Created by JP on 2/11/16.
//  Copyright © 2016 tpham44. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager



class ViewController: UIViewController {

    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources Bthat can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {
        
        
        TwitterClient.sharedInstance.loginWithCompletion(){
            (user: User?, error: NSError?) in
            if user != nil{
                
                //perform segue
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else{
                //handle login error
            }
            
        }
    }
}