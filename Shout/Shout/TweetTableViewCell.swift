//
//  TweetTableViewCell.swift
//  Shout
//
//  Created by Nelson Crespo on 9/30/14.
//  Copyright (c) 2014 Copypastel. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var flavorLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    var dateFormatter: NSDateFormatter = NSDateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateFormatter.dateFormat = "eee MMM dd HH:mm:ss ZZZZ yyyy"
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fromTweet(tweet: Tweet) {
        usernameLabel.text = "@\(tweet.user.username)"
        flavorLabel.text = "expouses"
        tweetTextLabel.text = tweet.text
        
        var timeFormatter = TTTTimeIntervalFormatter()
        var date = dateFormatter.dateFromString(tweet.timestamp)
        var since = timeFormatter.stringForTimeInterval(date!.timeIntervalSince1970 - NSDate().timeIntervalSince1970)
        timestampLabel.text = since
    }

}
