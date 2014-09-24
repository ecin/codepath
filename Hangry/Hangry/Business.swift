//
//  Business.swift
//  Hangry
//
//  Created by Nelson Crespo on 9/23/14.
//  Copyright (c) 2014 Copypastel. All rights reserved.
//

import Foundation
import UIKit

private var Cache: [Business?] = []
private var SingletonClient = Business.Client(consumerKey: "-UGIOXFd46cE0zWHcZj8sw", consumerSecret: "DfQFnowVsGRTz4geC3jGEhQFLy4", accessToken: "VVj_Z5Bu5Prz0w8GzJQ2-4_oLexyGdLQ", accessSecret: "-vS6Y6rb2lhDoHry4h7wvgbAKqg")
private var DefaultSearch: Business.Search = Business.Search()

class Business {
    
    var phone: String?
    var id: String?
    var imageURL: NSURL?
    var image: UIImage?
    var categories: [String] = []
    var url: String?
    var name: String?
    var description: String?
    var rating: Int?
    var ratingImageURL: NSURL?
    var reviewCount: Int?
    
    private class Client: BDBOAuth1RequestOperationManager {
        var accessToken: String!
        var accessSecret: String!
        
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
            self.accessToken = accessToken
            self.accessSecret = accessSecret
            var baseUrl = NSURL(string: "http://api.yelp.com/v2/")
            super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
            
            var token = BDBOAuthToken(token: accessToken, secret: accessSecret, expiration: nil)
            self.requestSerializer.saveAccessToken(token)
        }
        
        func searchWithTerm(term: String, parameters: [String:String] = [:], success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
            // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
//            var parameters = ["term": term, "location": "San Francisco"]
            return self.GET("search", parameters: parameters, success: success, failure: failure)
        }
    }
    
    class Search {
        // class variables aren't yet available in Swift
        class func setDefaultSearch(search: Search) {
            DefaultSearch = search
        }
        
        class func getDefaultSearch() -> Search {
            return DefaultSearch
        }
        
        enum Sort {
            case Matched, Distance, Rating
        }
        
        var term: String = ""
        var categories: [String] = []
        var limit: Int = 20
        var offset: Int = 0
        var radius: Int = 1000
        var hasDeals: Bool = false
        var location: String = "San Francisco"
        var sortBy: Sort = Sort.Matched
        
        private func parameters() -> [String:String] {
            var dictionary: [String:String] = [:]
            dictionary["term"] = self.term
//            dictionary["categories"] = ",".join(self.categories)
            dictionary["limit"] = String(self.limit)
            dictionary["offset"] = String(self.offset)
            dictionary["radius"] = String(self.radius)
            dictionary["has_deals"] = self.hasDeals ? "0" : "1"
            dictionary["location"] = self.location
            
           switch self.sortBy {
           case .Matched:
               dictionary["sort"] = "0"
           case .Distance:
               dictionary["sort"] = "1"
           default:
               dictionary["sort"] = "2"
           }
            
            return dictionary
        }
        
        func execute(success: ([Business?]) -> (), failure: (NSError) -> ()) {
            SingletonClient.searchWithTerm(term,
                parameters: self.parameters(),
                success: { (request: AFHTTPRequestOperation!, response: AnyObject!) in
                    var businesses = (response as NSDictionary)["businesses"] as Array<NSDictionary>
                    
                    // Clear cache before adding more items
                    Cache.removeAll(keepCapacity: true)
                    for details in businesses {
                        var business = Business()
                        business.id = details["id"] as? String
                        business.name = details["name"] as? String
                        business.description = details["snippet_text"] as? String
                        println(business.description!)
                        business.phone = details["display_phone"] as? String
                        business.url = details["url"] as? String
                        business.rating = details["rating"] as? Int
                        business.reviewCount = details["review_count"] as? Int
                        
                        var categoryPairs = details["categories"] as Array<Array<String>>
                        business.categories = categoryPairs.map { pair in pair[0] }
                        business.imageURL = NSURL(string: details["image_url"] as String)
                        business.ratingImageURL = NSURL(string: details["rating_img_url"] as String)
                        
                        Cache.append(business)
                    }
                    
                    success(Cache)
                },
                failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                    failure(error)
            })
        }
    }

    class func count() -> Int {
        return Cache.count
    }
    
    class func clear() {
        Cache.removeAll(keepCapacity: true)
    }
    
    class func get(index: Int) -> Business? {
        if (Cache.count < index) {
            return nil
        } else {
            return Cache[index]
        }
    }

}