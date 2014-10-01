//
//  ViewController.swift
//  Shout
//
//  Created by Nelson Crespo on 9/30/14.
//  Copyright (c) 2014 Copypastel. All rights reserved.
//

import Accounts
import Social
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tweetsTableView: UITableView!
    @IBOutlet weak var refreshControl: UIRefreshControl!
    var account: ACAccount?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        
        Tweet.authenticate("XOLEHC3pAniBxG2CsQ5tYisl6", consumerSecret: "kylFhjIuX36JHftNacmz8EKHpAwSE6h7fHX4wa0jCignhOp0as") {
            accounts in
            self.account = accounts[0]
            self.refresh(UIRefreshControl())
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Tweet.count()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tweetsTableView.dequeueReusableCellWithIdentifier("tweetCell") as TweetTableViewCell
        let tweet = Tweet.get(indexPath.row)
        
        cell.fromTweet(tweet)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("details") as TweetDetailViewController
        let tweet = Tweet.get(indexPath.row)
        detailsViewController.tweet = tweet
        detailsViewController.account = account
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        var indexPath: NSIndexPath = self.tweetsTableView.indexPathForSelectedRow()!
//        var controller = segue.destinationViewController as TweetDetailViewController
//        controller.tweet = Tweet.get(indexPath.row)
//        controller
//        println("Segue preparation complete!")
//    }
    
    @IBAction func tweet(sender: UIBarButtonItem) {
        var tweetSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        self.presentViewController(tweetSheet, animated: true, completion: {})
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        if account != nil {
            Tweet.fetch(account!, success: {
                tweets in
                self.tweetsTableView.reloadData()
                self.refreshControl.endRefreshing()
            })
        }
    }
}

