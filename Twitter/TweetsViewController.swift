//
//  TweetsViewController.swift
//  Twitter
//
//  Created by JP on 2/19/16.
//  Copyright © 2016 tpham44. All rights reserved.
//

import UIKit


protocol MainTweetDelegate{
    func passingCellData(omgTweet: Tweet)
}

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate {
    
    var delegate:MainTweetDelegate?
    
    var tweets: [Tweet]?
    
    var refreshControl: UIRefreshControl!
    let delay = 3.0 * Double(NSEC_PER_SEC)
    
    var isMoreDataLoading = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //adding the tableview
        tableView.delegate = self
        tableView.dataSource = self
        
        //here code for pull to refresh
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        
        
        
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        
        //ended code for pull to refresh
        
        //for the autolayout of the tableview row
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        
        
        tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    //finishing pull to refresh
    func delay(delay:Double, closure:() -> ()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        delay(1, closure: {
            self.refreshControl.endRefreshing()
        })
    }
    
    //finished pull to refresh
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //tvds (tableview data source implementation)
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetsTableViewCell", forIndexPath: indexPath) as! TweetsTableViewCell
        cell.tweet = tweets![indexPath.row]
        return cell
    }
    
    @IBAction func onLogout(sender: UIBarButtonItem) {
        if(User.currentUser != nil) {
            User.currentUser!.logout()
        }else{
        self.dismissViewControllerAnimated(true, completion: nil)
        }
       

    }
    
//    @IBAction func onLogout(sender: AnyObject) {
//        if(User.currentUser != nil) {
//            User.currentUser!.logout()
//        }
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }


    
    
    //pass data to "DetailsViewController"
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if (segue.identifier == "fromCellToDetailsPage") {
            
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            let tweeted = tweets![indexPath!.row]
            let detailTweetViewController = segue.destinationViewController as! TweetsDetailViewController
            detailTweetViewController.detailTweet = tweeted
            
        }
        
        
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
