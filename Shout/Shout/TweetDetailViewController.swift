//
//  TweetDetailViewController.swift
//  Shout
//
//  Created by Nelson Crespo on 9/30/14.
//  Copyright (c) 2014 Copypastel. All rights reserved.
//

import Accounts
import UIKit
import Social

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    var tweet: Tweet?
    var account: ACAccount?
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = "@\(tweet!.user.username)"
        tweetTextLabel.text = tweet?.text
        nameTextLabel.text = tweet!.user.name
        
        setFavoriteIcon(tweet!.favorite)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func swipeDown(sender: UISwipeGestureRecognizer) {
        self.dismissViewControllerAnimated(true, {})
    }
    @IBAction func favorite(sender: UIButton) {
        var id = tweet!.id
        if tweet!.favorite {
            self.tweet!.favorite = false
            Tweet.unfavorite(account!, id: id, success: {
                self.tweet!.favorite = false
            })
        } else {
            self.setFavoriteIcon(true)
            Tweet.favorite(account!, id: id, success: {
                self.tweet!.favorite = true
            })
        }
    }
    
    func setFavoriteIcon(favorited: Bool) {
        if favorited {
            favoriteButton.setImage(UIImage(named: "iconmonstr-bookmark-24-icon-256"), forState: UIControlState.Normal)
        } else {
            favoriteButton.setImage(UIImage(named: "iconmonstr-bookmark-22-icon-256"), forState: UIControlState.Normal)
        }
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
