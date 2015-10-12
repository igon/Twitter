//
//  DetailTweetViewController.swift
//  Twitter
//
//  Created by Gonzalez, Ivan on 10/4/15.
//  Copyright © 2015 Gonzalez, Ivan. All rights reserved.
//

import UIKit

class DetailTweetViewController: UIViewController {

    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    private var curTweet:Tweet!
    

    internal func setTweet(tweetToDisplay:Tweet) {

        
        self.curTweet = tweetToDisplay
    }
    
    override func viewDidLoad() {
        tweetLabel.text = curTweet.text
        handleLabel.text = "@" + (curTweet.user?.screenName)!
        nameLabel.text = curTweet.user?.name
        profileImageView.setImageWithURL(NSURL(string:(curTweet.user?.profileImageUrl)!)!)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        
        let params: NSDictionary = NSDictionary(object: curTweet!.id!, forKey: "id")
        
        
        TwitterClient.sharedInstance.retweet(params) { (tweet, error) -> () in
            return
        }
    }
    
    
    @IBAction func onReply(sender: AnyObject) {
        
    }
    
    
    
    @IBAction func onFavorite(sender: AnyObject) {
        let params: NSDictionary = NSDictionary(object: curTweet!.id!, forKey: "id")
        
        TwitterClient.sharedInstance.favorite(params, completion: {(tweet, error) -> () in
            if tweet != nil {
                return
            }
        })
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "ReplyTweetSegue") {
            

            let composeTweetViewController = segue.destinationViewController as! ComposeTweetViewController
            composeTweetViewController.tweet = curTweet
        } 
    }
    
}
