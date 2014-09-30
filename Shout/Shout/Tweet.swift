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
private var tweets: NSArray = []

class Tweet {
    class func fetch(limit: Int = 20, offset: Int = 0) {
        if accounts.count == 0 {
            println("There are no Twitter accounts configured. You can add or create a Twitter account in Settings.")
        } else {
            let twitterAccount = accounts[0] as ACAccount
            let requestURL = NSURL(string: "https://api.twitter.com/1/statuses/home_timeline.json")
            
            let parameters: [String:String] = [
                "count": String(limit),
                "offset": String(offset),
                "include_entities": "0",
            ]
            
            let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: parameters)
            
            request.account = twitterAccount
            request.performRequestWithHandler() {
                data, response, error in
                var error: NSError?
                let dataSource = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error: &error) as NSArray
                
                tweets = dataSource
            }
        }
    }
    
    init(fromDictionary: NSDictionary) {
        
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