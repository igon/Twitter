//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Gonzalez, Ivan on 10/4/15.
//  Copyright © 2015 Gonzalez, Ivan. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeElapseLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIImageView!
    @IBOutlet weak var retweetButton: UIImageView!
    @IBOutlet weak var replyButton: UIImageView!
    @IBOutlet weak var tweetBodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
