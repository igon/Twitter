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


class TwitterClient: BDBOAuth1RequestOperationManager {

    class var sharedInstance: TwitterClient{
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL,
                consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret)
        }
    
        return Static.instance
        
    }
}
