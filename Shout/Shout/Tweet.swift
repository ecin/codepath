//
//  Tweet.swift
//  Shout
//
//  Created by Nelson Crespo on 9/30/14.
//  Copyright (c) 2014 Copypastel. All rights reserved.
//

import Accounts
import Foundation
import Social

private var accounts: [ACAccount] = []
private var tweets: [Tweet] = []

class Tweet {
    class User {
        var username: String = ""
        var name: String = ""
        var description: String = ""
        
        init() { }
        
        init(dictionary: NSDictionary) {
            username = dictionary["screen_name"] as String
            name = dictionary["name"] as String
            description = dictionary["description"] as String
        }
    }
    
    class func count() -> Int {
        return tweets.count
    }
    
    class func get(index: Int) -> Tweet {
        return tweets[index]
    }
    
    class func favorite(account: ACAccount, id: Int, success: () -> ()) {
        let requestURL = NSURL(string: "https://api.twitter.com/1.1/favorites/create.json")
        
        let parameters: [String:String] = [
            "id": String(id)
        ]
        
        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.POST, URL: requestURL, parameters: parameters)
        
        request.account = account
        request.performRequestWithHandler() {
            data, response, error in
            success()
        }
    }
    
    class func unfavorite(account: ACAccount, id: Int, success: () -> ()) {
        let requestURL = NSURL(string: "https://api.twitter.com/1.1/favorites/create.json")
        
        let parameters: [String:String] = [
            "id": String(id)
        ]
        
        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.DELETE, URL: requestURL, parameters: parameters)
        
        request.account = account
        request.performRequestWithHandler() {
            data, response, error in
            success()
        }
    }
    
    class func fetch(account: ACAccount, limit: Int = 20, offset: Int = 0, success: (tweets: [Tweet]) -> ()) {
        let requestURL = NSURL(string: "https://api.twitter.com/1/statuses/home_timeline.json")
        
        let parameters: [String:String] = [
            "count": String(limit),
            "offset": String(offset),
            "include_entities": "0",
        ]
        
        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: parameters)
        
        request.account = account
        request.performRequestWithHandler() {
            data, response, error in
            var error: NSError?
            let dataSource = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error: &error) as NSArray
            
            tweets = []
            for data in dataSource {
                var tweet = Tweet(dictionary: data as NSDictionary)
                tweets.append(tweet)
            }
            
            success(tweets: tweets)
        }
    }
    
    var id: Int = 0
    var user: User = User()
    var text: String = ""
    var timestamp: String = ""
    var favorite: Bool = false
//    var createdAt: NSDate = NSDate()
    
    init(dictionary: NSDictionary) {
        id = dictionary["id"] as Int
        user = User(dictionary: dictionary["user"] as NSDictionary)
        text = dictionary["text"] as String
        timestamp = dictionary["created_at"] as String
        favorite = dictionary["favorited"] as Bool
    }
    
    class func authenticate(consumerKey: String, consumerSecret: String, success: ([ACAccount]) -> ()) -> Bool {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
            granted, error in
            if granted {
                accounts = accountStore.accountsWithAccountType(accountType) as [ACAccount]
                success(accounts)
            } else {
                println("Boo, need to set up Twitter account first")
            }
        }
        
        return true
    }
    
}