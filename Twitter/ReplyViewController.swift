//
//  ReplyViewController.swift
//  Twitter
//
//  Created by JP on 3/1/16.
//  Copyright © 2016 tpham44. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController, UITextViewDelegate {
  
    
    @IBOutlet weak var replyTextField: UITextView!
    
    @IBOutlet weak var sendButton: UIButton!
    
    var replyId: Int?
    //    var replyHandle: String?
    //    let userDefaults = NSUserDefaults.standardUserDefaults()
    //
    //    var placeholderLabel : UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        //        replyHandle = userDefaults.stringForKey("detailReplyTo_Handle")
        //        replyTextField!.text = replyHandle
        //
        //
        
        replyTextField.becomeFirstResponder()
        
        //        replyTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func insertTwitterHandle(handle: String) {
        replyTextField.text = handle
        replyTextField.delegate?.textViewDidChange!(replyTextField)
    }
    
    
    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func onSend(sender: AnyObject) {
        
        TwitterClient.sharedInstance.postTweet(replyTextField.text!, replyId: replyId, completion: {(success, error) -> () in
            if success != nil {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
        
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}