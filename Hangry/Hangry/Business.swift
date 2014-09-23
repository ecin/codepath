//
//  Business.swift
//  Hangry
//
//  Created by Nelson Crespo on 9/23/14.
//  Copyright (c) 2014 Copypastel. All rights reserved.
//

import Foundation
import UIKit

private var Cache: [Business] = []
private var SingletonClient = Business.Client(consumerKey: "-UGIOXFd46cE0zWHcZj8sw", consumerSecret: "DfQFnowVsGRTz4geC3jGEhQFLy4", accessToken: "VVj_Z5Bu5Prz0w8GzJQ2-4_oLexyGdLQ", accessSecret: "-vS6Y6rb2lhDoHry4h7wvgbAKqg")

class Business {
    
    var phone: String?
    var id: String?
    var image: UIImage?
    var categories: [String] = []
    var url: String?
    var name: String?
    var rating: Int?
    var ratingImage: UIImage?
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
//            dictionary["has_deals"] = String(self.hasDeals)
            dictionary["location"] = self.location
            
//            switch self.sortBy {
//            case .Matched:
//                dictionary["sort"] = "matched"
//            case .Distance:
//                dictionary["sort"] = "distance"
//            default:
//                dictionary["sort"] = "rating"
//            }
            
            return dictionary
        }
        
        func execute(success: ([Business]) -> (), failure: (NSError) -> ()) {
            if Cache.isEmpty {
                print(self.parameters())
                SingletonClient.searchWithTerm(term,
                    parameters: self.parameters(),
                    success: { (request: AFHTTPRequestOperation!, response: AnyObject!) in
                        success(Cache)
                        var businesses = (response as NSDictionary)["businesses"] as Array<NSDictionary>
                        
                        for details in businesses {
                            var business = Business()
                            business.id = details["id"] as? String
                            business.name = details["name"] as? String
                            business.phone = details["display_phone"] as? String
                            business.url = details["url"] as? String
                            business.rating = details["rating"] as? Int
                            business.reviewCount = details["review_count"] as? Int
                            
                            var categoryPairs = details["categories"] as Array<Array<String>>
                            business.categories = categoryPairs.map { pair in pair[0] }
                            var imageUrl = details["image_url"] as? String
                            if (imageUrl != nil) {
                                var url = NSURL(string: imageUrl!)
                                business.image = UIImage(data: NSData(contentsOfURL: url))
                            }
                            
                            Cache.append(business)
                        }
                        
                        success(Cache)
                    },
                    failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                        failure(error)
                    })
            } else {
                success(Cache)
            }
        }
    }

    class func get(index: Int) -> Business {
        return Business()
    }

}