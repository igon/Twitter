//
//  MenuViewController.swift
//  Twitter
//
//  Created by Gonzalez, Ivan on 10/4/15.
//  Copyright © 2015 Gonzalez, Ivan. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    var viewControllers: [UIViewController] = [ (UIApplication.sharedApplication().delegate as! AppDelegate).storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationViewController") as UIViewController,(UIApplication.sharedApplication().delegate as! AppDelegate).storyboard.instantiateViewControllerWithIdentifier("MentionsNavigationViewController") as UIViewController, (UIApplication.sharedApplication().delegate as! AppDelegate).storyboard.instantiateViewControllerWithIdentifier("ProfilePageViewController") as UIViewController]
    
    var activieViewController: UIViewController? {
        didSet(oldViewControllerOrNil) {
            if let oldVC = oldViewControllerOrNil {
                oldVC.willMoveToParentViewController(nil)
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
            }
            
            if let newVC = activieViewController {
                self.addChildViewController(newVC)
                newVC.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
                newVC.view.frame = self.contentView.bounds
                self.contentView.addSubview(newVC.view)
                newVC.didMoveToParentViewController(self)
            }
        }
    }
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var homeButton: UIButton!
    
    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var mentionButton: UIButton!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    
    @IBOutlet weak var sidebarView: UIView!
    
    @IBOutlet weak var contentViewXConstraint: NSLayoutConstraint!
    
    @IBOutlet var swipeGestureLeft: UISwipeGestureRecognizer!
    
    @IBOutlet var swipeGestureRight: UISwipeGestureRecognizer!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var profileScreenName: UILabel!
    
    
    @IBAction func onSwipeLeft(sender: AnyObject) {
        let swipe = (sender as! UISwipeGestureRecognizer)
        if swipe.state == .Ended {
            print("\(swipe.direction.rawValue)")
            UIView.animateWithDuration(0.35) { () -> Void in
                self.contentViewXConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    @IBAction func onSwipeRight(sender: AnyObject) {
        
       let swipe = (sender as! UISwipeGestureRecognizer)
        if swipe.state == .Ended {
            UIView.animateWithDuration(0.35) { () -> Void in
                    self.contentViewXConstraint.constant = -250
                    self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func onButtonTap(sender: AnyObject) {
        
        if (sender as! UIButton) == homeButton {
            self.activieViewController =  viewControllers.first
        } else if (sender as! UIButton) == mentionButton {
            self.activieViewController =  viewControllers[1]
        } else if (sender as! UIButton) == profileButton {
            let profileViewController = viewControllers.last as! ProfilePageViewController
            profileViewController.user = User.currentUser!
            profileViewController.exitButtonHide = true
            self.activieViewController =  viewControllers.last
        }  else if (sender as! UIButton) == logoutButton {
            User.currentUser?.logout()
            return
        }
        
        UIView.animateWithDuration(0.35) { () -> Void in
            self.contentViewXConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeGestureRight.direction = .Right
        swipeGestureLeft.direction = .Left
        
        contentViewXConstraint.constant = 0
        activieViewController = viewControllers.first
        // Do any additional setup after loading the view.
        
        self.profileImageView.setImageWithURL(NSURL(string: User.currentUser!.profileImageUrl!), placeholderImage: UIImage(named: "Waiting"))
        self.profileName.text = User.currentUser!.name
        self.profileScreenName.text = "@" + User.currentUser!.screenName!
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
