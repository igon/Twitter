//
//  ProfilePageViewController.swift
//  Twitter
//
//  Created by Gonzalez, Ivan on 10/4/15.
//  Copyright © 2015 Gonzalez, Ivan. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIViewController {

    var user: User?
    var exitButtonHide: Bool = false
    
    @IBOutlet weak var profileHeaderView: UIImageView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var profileNameLabel: UILabel!
    
    @IBOutlet weak var profileScreenNameLabel: UILabel!
    
    @IBOutlet weak var profileDescriptionLabel: UILabel!
    
    @IBOutlet weak var profileLocationLabel: UILabel!
    
    @IBOutlet weak var profileLocationLabelTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tweetsTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tweetsLabel: UILabel!
    
    @IBOutlet weak var followingLabel: UILabel!
    
    @IBOutlet weak var followersLabel: UILabel!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    
    @IBOutlet weak var exitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if user != nil {
            populateView()
            
            if exitButtonHide == true {
                exitButton.hidden = true
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateView() {
        if user!.profileImageUrl != nil {
            self.profileImageView.setImageWithURL(NSURL(string: user!.profileImageUrl!), placeholderImage: UIImage(named: "Waiting"))
        }
        
        if user!.profileHeaderImageUrl != nil {
            self.profileHeaderView.setImageWithURL(NSURL(string: user!.profileHeaderImageUrl!), placeholderImage: UIImage(named: "Waiting"))
        }
        
        profileNameLabel.text = user!.name
        profileScreenNameLabel.text = "@" + user!.screenName!
        profileDescriptionLabel.text = user!.tagLine
        
        if user!.location != nil {
            profileLocationLabel.text = user!.location! as String
        } else {
            profileLocationLabelTopConstraint.constant = 0
        }
        
        
        tweetsLabel.text = "\(user!.numberofTweets!) tweets"
        followingLabel.text = "\(user!.numberofFollowing!) following"
        followersLabel.text = "\(user!.numberofFollowers!) followers"
        
        var _: NSDictionary
        
        self.view.layoutIfNeeded()
    }

    
    @IBAction func onTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
