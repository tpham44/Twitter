//
//  TweetsDetailViewController.swift
//  Twitter
//
//  Created by JP on 3/1/16.
//  Copyright © 2016 tpham44. All rights reserved.
//

import UIKit


var detailTweet: Tweet!


class TweetsDetailViewController: UIViewController {
//    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var tweetContentText: UILabel!
    @IBOutlet weak var timeCreator: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favCountLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
   
    
    // assign data from Tweets View Controller
    var detailTweet: Tweet!
    var replyID: Int?
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var replyTo: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetContentText.text = detailTweet!.text
        userName.text = detailTweet!.user!.name
        userHandle.text = "@\(detailTweet!.user!.screenname!)"
        
//
//        
        let imageUrl = detailTweet!.user?.profileImageUrl!
        print("imge is hererer\(imageUrl)")
//        
        profileImage.setImageWithURL(NSURL(string: imageUrl!)!)
        //convert integer of Counts to String
        
        retweetCountLabel.text = String(detailTweet!.retweetCount!)
        
        //****** likeCount was declare somewhere else
        favCountLabel.text = String(detailTweet!.likeCount!)
        
        retweetCountLabel.text! == "0" ? (retweetCountLabel.hidden = true) : (retweetCountLabel.hidden = false)
        favCountLabel.text! == "0" ? (favCountLabel.hidden = true) : (favCountLabel.hidden = false)
        timeCreator.text = String(detailTweet.Time)
        userDefaults.setValue(replyTo, forKey: "detailReplyTo_Handle")
        
//            //transfer all values from tabelViewCell to TweetsDetailsViewControl
//        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onRetweet(sender: AnyObject) {
    
        self.retweetCountLabel.text = String(self.detailTweet!.retweetCount! + 1)
        
        
    }
    
    
    @IBAction func onFav (sender: AnyObject) {
        
        self.favCountLabel.text = String(self.detailTweet!.likeCount! + 1)
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//      
//            if (segue.identifier == "fromCellToDetailsPage") {
//                
//                let button = sender as! UIButton
//                let view = button.superview!
//                let cell = view.superview as! TweetsTableViewCell
//                
//                let profileViewController = segue.destinationViewController as! ProfileViewController
    
                //                let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
//                let tweetss = tweets![indexPath!.row]
//                let detailTweetViewController = segue.destinationViewController as! TweetsDetailViewController
//                detailTweetViewController.detailTweet = tweetss
                
    
    

        
        //"segueToProfileView"
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    //}
    

}
