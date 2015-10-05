//
//  ComposeTweetViewController.swift
//  Twitter
//
//  Created by Gonzalez, Ivan on 10/4/15.
//  Copyright © 2015 Gonzalez, Ivan. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    
    var tweet:Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = User.currentUser?.name
        tweetLabel.text = User.currentUser?.screenName
        profileImageView.setImageWithURL(NSURL(string: (User.currentUser?.profileImageUrl)!)!)
        
        if tweet != nil {
            tweetTextView.text = "@" + (tweet!.user?.screenName)!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        
        let params: NSMutableDictionary = NSMutableDictionary()
        
        var  tweetDraft = tweetTextView.text
        
        if tweetDraft.characters.count > 140 {
            
            tweetDraft = tweetDraft.substringToIndex(tweetDraft.startIndex.advancedBy(140))
        }
        
        
        params["status"] = tweetDraft
        
        if tweet != nil {
            params["in_reply_to_status_id"] = tweet?.id
        }
        
        TwitterClient.sharedInstance.tweet(params) { (tweet, error) -> () in
            self.navigationController?.popToRootViewControllerAnimated(true)
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
