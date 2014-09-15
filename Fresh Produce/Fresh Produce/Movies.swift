//
//  Movies.swift
//  Fresh Produce
//
//  Created by Nelson Crespo on 9/14/14.
//  Copyright (c) 2014 Copypastel. All rights reserved.
//

import Foundation

private var Cache: [Movie] = []
private let Key = "t2quq5swmxtkux9ebfurexje"
private let Endpoint = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json"

class Movie {
    class func all() -> [Movie] {
        if Cache.isEmpty {
            let request = NSMutableURLRequest(URL: NSURL.URLWithString("\(Endpoint)?apikey=\(Key)"))
            var response: NSURLResponse?
            var error: NSError?
            
            var data: NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)!
            
            let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as NSDictionary
            let movies = dictionary["movies"] as Array<NSDictionary>
            for (data) in movies {
                Cache.append(Movie(data: data))
            }
        }
        
        return Cache
    }
    
    class func count() -> Int {
        return Cache.count
    }
    
    class func get(index: Int) -> Movie {
        return Cache[index]
    }
    
    var data: NSDictionary
    
    init(data: NSDictionary) {
        self.data = data
    }
    
    func title() -> String { return self.data["title"]! as NSString }
    func description() -> String { return self.data["description"]! as NSString }
}
