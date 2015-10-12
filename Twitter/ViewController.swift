//
//  ViewController.swift
//  Twitter
//
//  Created by Gonzalez, Ivan on 10/3/15.
//  Copyright © 2015 Gonzalez, Ivan. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onLogin(sender: AnyObject) {

         TwitterClient.sharedInstance.loginWithCompletion()  {
                (user: User?, error: NSError?) in
                if (user != nil) {
                    self.performSegueWithIdentifier("loginSegue", sender: self)

                    // perform segue
//                    self.performSegueWithIdentifier("homeSegue", sender: self)
                } else {
                    // handle login error
                }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}

