//
//  TwitterClient.swift
//  Twitter
//
//  Created by Gonzalez, Ivan on 10/3/15.
//  Copyright © 2015 Gonzalez, Ivan. All rights reserved.
//

import UIKit

let twitterConsumerKey = "8fuDoWmk73i4cc93NK1gfHz6Q"
let twitterConsumerSecret = "0C39C9C2vG8tOLP4CP0UTDlwhblJB6EZNInTudK2XpG6bSuTcx"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")
let twitterAuthorizeEndPoint = "https://api.twitter.com/oauth/authorize?oauth_token="

class TwitterClient: BDBOAuth1RequestOperationManager {
    var loginWithCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient{
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL,
                consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret)
        }
    
        return Static.instance
        
    }
    
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginWithCompletion = completion
        
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL:  NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got request token \(requestToken)")
            
            let authURL = NSURL(string: twitterAuthorizeEndPoint + "\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                print("failed to get request token \(error)")
                self.loginWithCompletion?(user: nil, error: error)
        }
    }
    
    func openUrl(url: NSURL) {
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got access token")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                //   println(" got user credentials: \(response)")
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                print(" got user credentials: \(user.name)")
                self.loginWithCompletion?(user: user, error: nil)
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    print(" failed to get user credentials")
                    self.loginWithCompletion?(user: nil, error: error)
            })
            }) { (error: NSError!) -> Void in
                print("failed to get access token")
                print("failed to get request token \(error)")
                self.loginWithCompletion?(user: nil, error: error)
        }
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //println(" got user timeline: \(response)")
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("something went wrong \(error)")
                completion(tweets: nil, error: error)
        })
        
    }
    
    func favorite(params: NSDictionary, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/favorites/create.json?id=" + (params["id"] as! String), parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            print("successful ")
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("something went wrong \(error)")
                completion(tweet: nil, error: error)
        })
    }
    
    func retweet(params: NSDictionary, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/retweet/" + (params["id"] as! String) + ".json" , parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            print("successful ")
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("something went wrong \(error)")
                completion(tweet: nil, error: error)
        })
    }
    
    func tweet(params: NSDictionary, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            print("successful ")
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("something went wrong \(error)")
                completion(tweet: nil, error: error)
        })
    }
}
