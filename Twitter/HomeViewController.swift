//
//  HomeViewController.swift
//  Twitter
//
//  Created by Gonzalez, Ivan on 10/4/15.
//  Copyright © 2015 Gonzalez, Ivan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var homeTableView: UITableView!
    
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    var tweets:[Tweet]?
    var rowSelected: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.rowHeight = UITableViewAutomaticDimension
        homeTableView.estimatedRowHeight = 127
        homeTableView.delegate = self
        homeTableView.dataSource = self
        self.homeTableView.addSubview(refreshControl)
        
        self.refreshControl.addTarget(self, action: "loadTweets", forControlEvents: UIControlEvents.ValueChanged)
        
        loadTweets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        }
        
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tweets![indexPath.row].populateCell(indexPath.row, tableView: tableView)
        let tapGesture = UITapGestureRecognizer(target: self, action: "onTap:")
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 1
        cell.profileImageView.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    func onTap(sender: AnyObject) {
        
        let tapView = sender.view as? UIImageView
        
        if tapView != nil {
            rowSelected = tapView!.tag
            self.performSegueWithIdentifier("ProfileSegue", sender: self)
        }
    }

    func loadTweets() {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            if tweets != nil {
                    self.tweets = tweets
                    dispatch_async(dispatch_get_main_queue()) {
                        self.homeTableView.reloadData()
                        if (self.refreshControl.refreshing == true) {
                            self.refreshControl.endRefreshing()
                        }

                    }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    if (self.refreshControl.refreshing == true) {
                        self.refreshControl.endRefreshing()
                    }
                }
                print("error getting home timeline")
            }
            

        })
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        rowSelected = indexPath.row
        self.performSegueWithIdentifier("tweetDetail", sender: self)
        
  //      tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    @IBAction func onLogut(sender: AnyObject) {
     User.currentUser?.logout()
    }
    
    
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "tweetDetail" {
            let detailTweetController = segue.destinationViewController as!DetailTweetViewController
            detailTweetController.setTweet(tweets![rowSelected])
            homeTableView.deselectRowAtIndexPath(NSIndexPath(forRow: rowSelected, inSection: 0), animated: false)
        } else if segue.identifier == "ProfileSegue" {
            let profileViewContoller = segue.destinationViewController as! ProfilePageViewController
            profileViewContoller.user = tweets![rowSelected].user
        }
        
        
    }


}
