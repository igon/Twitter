//
//  MentionsViewController.swift
//  Twitter
//
//  Created by Gonzalez, Ivan on 10/4/15.
//  Copyright © 2015 Gonzalez, Ivan. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tweets: [Tweet]?
    var tableViewChanged: Bool = true
    
    var refreshControl: UIRefreshControl = UIRefreshControl()
    var selectedRow: Int?

    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 115.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.layoutMargins = UIEdgeInsetsZero
        self.tableView.addSubview(refreshControl)
        self.refreshControl.addTarget(self, action: "loadTableViewData", forControlEvents: UIControlEvents.ValueChanged)

        loadTableViewData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadTableViewData() {
        activityIndicatorView.startAnimating()
        TwitterClient.sharedInstance.mentionsTimelineWithParams(nil, completion: { (tweets, error) -> () in
            if tweets != nil {
                self.tweets = tweets
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }
            self.activityIndicatorView.stopAnimating()
            if (self.refreshControl.refreshing == true) {
                self.refreshControl.endRefreshing()
            }
            self.tableViewChanged = false
        })
    }

    // UITableViewDelegate
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            if tweets != nil {
                return tweets!.count
            }
            
            return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = populateCell(tweets![indexPath.row], row: indexPath.row)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRow = indexPath.row
        //        self.performSegueWithIdentifier("TweetDetailSegue", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    func populateCell(tweet: Tweet, row: Int) -> TweetTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetTableViewCell
        cell.favoriteButton.backgroundColor = UIColor.clearColor()
        cell.retweetButton.backgroundColor = UIColor.clearColor()
        
        cell.profileNameLabel.text = tweet.user?.name
        cell.screenNameLabel.text = "@" + tweet.user!.screenName!
        
        let currentDate = NSDate()
        let timeInterval = currentDate.timeIntervalSinceDate(tweet.createdAt!)
        var timeToMention: String?
        var timeIntervalSec = timeInterval // secs
        
        if (timeIntervalSec < 60) {
            timeToMention = "\(Int(timeIntervalSec)) sec"
        } else {
            timeIntervalSec = timeIntervalSec/60 // mins
            if (timeIntervalSec < 60) {
                timeToMention = "\(Int(timeIntervalSec)) min"
            } else {
                timeIntervalSec = timeIntervalSec/24  // hours
                if (timeIntervalSec < 24) {
                    timeToMention = "\(Int(timeIntervalSec)) hr"
                } else {
                    timeIntervalSec = timeIntervalSec/30 // days
                    if (timeIntervalSec < 31) {
                        timeToMention = "\(Int(timeIntervalSec)) days"
                    } else {
                        timeIntervalSec = timeIntervalSec/12  // months
                        if (timeIntervalSec < 12) {
                            timeToMention = "\(Int(timeIntervalSec)) mon"
                        } else {
                            timeToMention = "\(Int(timeIntervalSec)) year"
                        }
                    }
                }
            }
        }
        
        cell.timeElapseLabel.text = timeToMention
        cell.tweetBodyLabel.text = tweet.text
        
        cell.profileImageView.setImageWithURL(NSURL(string: tweet.user!.profileImageUrl!))
        cell.profileImageView.tag = row
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "onTap:")
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 1
        cell.profileImageView.addGestureRecognizer(tapGesture)
        

        
        return cell
    }

}
