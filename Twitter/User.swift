//
//  User.swift
//  Twitter
//
//  Created by Gonzalez, Ivan on 10/4/15.
//  Copyright © 2015 Gonzalez, Ivan. All rights reserved.
//


import UIKit

let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"
var _currentUser: User?

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var profileUserName: String?
    var tagLine: String?
    var numberofFollowers: NSInteger?
    var numberofFollowing: NSInteger?
    var numberofTweets: NSInteger?
    var location: NSString?
    var profileHeaderImageUrl: String?

    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagLine = dictionary["description"] as? String
        numberofFollowers = dictionary["followers_count"] as? NSInteger
        numberofFollowing = dictionary["friends_count"] as? NSInteger
        numberofTweets = dictionary["listed_count"] as? NSInteger
        location = dictionary["location"] as? String
        profileHeaderImageUrl = dictionary["profile_background_image_url"] as? String

        self.dictionary = dictionary
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
        
            if _currentUser == nil {
                let data =  NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
            
                if data != nil {
                    do {
                        let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                        _currentUser = User(dictionary: dictionary)
                    } catch {
                        
                    }
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                do {
                    let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: [])
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                } catch {
                    
                }
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        
    }
}