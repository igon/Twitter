//
//  Tweet.swift
//  Twitter
//
//  Created by Gonzalez, Ivan on 10/4/15.
//  Copyright © 2015 Gonzalez, Ivan. All rights reserved.
//

import UIKit

import UIKit

class Tweet: NSObject {
    var id: String?
    var user: User?
    var text: String?
    var createdAt: NSDate?
    var createdAtString: NSString?
    var dictionary: NSDictionary
    var numberofRetweets: NSInteger
    var numberofFavorites: NSInteger
    var isRetweeted: Bool
    var isFavorited: Bool
    
    init(dictionary: NSDictionary) {
        id = dictionary["id_str"] as? String
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString! as String)
        numberofRetweets = dictionary["retweet_count"] as! NSInteger
        numberofFavorites =  dictionary["favorite_count"] as! NSInteger
        isRetweeted = dictionary["retweeted"] as! Bool
        isFavorited = dictionary["favorited"] as! Bool
        self.dictionary =  dictionary
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    
    func populateCell(tableView: UITableView) -> TweetTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetTableViewCell
        
        cell.favoriteButton.backgroundColor = UIColor.clearColor()
        cell.retweetButton.backgroundColor = UIColor.clearColor()
        
        cell.profileNameLabel.text = user?.name
        cell.screenNameLabel.text = "@" + user!.screenName!

        let currentDate = NSDate()
        let timeInterval = currentDate.timeIntervalSinceDate(createdAt!)
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
        cell.tweetBodyLabel.text = text
        
        cell.profileImageView.setImageWithURL(NSURL(string: user!.profileImageUrl!))
        
        
        return cell
    }
}