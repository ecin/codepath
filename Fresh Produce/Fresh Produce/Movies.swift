//
//  Movies.swift
//  Fresh Produce
//
//  Created by Nelson Crespo on 9/14/14.
//  Copyright (c) 2014 Copypastel. All rights reserved.
//

import Foundation
import UIKit

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
            
            if (error == nil) {
                let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as NSDictionary
                let movies = dictionary["movies"] as Array<NSDictionary>
                for (data) in movies {
                    Cache.append(Movie(data: data))
                }
            }
        }
        
        return Cache
    }
    
    class func refresh() -> [Movie] {
        Cache.removeAll(keepCapacity: true)
        return all()
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
    func synopsis() -> String { return self.data["synopsis"]! as NSString }
    func year() -> String {
        var releaseDate = self.data["release_dates"]!["theater"]! as String
        var year = Array(releaseDate)[0...3]
        return String(seq: year)
    }
    func rating() -> Int {
        return self.data["ratings"]!["audience_score"]! as Int
    }
    
    enum ImageSize {
        case Detailed, Original, Profile, Thumbnail
    }
    
    private func posters() -> NSDictionary {
        return self.data["posters"]! as NSDictionary
    }
    
    func poster(size: ImageSize = ImageSize.Thumbnail) -> UIImage {
        var uri = posters()["original"]! as String
        
        switch size {
            case .Detailed:
                uri = uri.stringByReplacingOccurrencesOfString("tmb", withString: "det")
            case .Original:
                uri = uri.stringByReplacingOccurrencesOfString("tmb", withString: "ori")
            case .Profile:
                uri = uri.stringByReplacingOccurrencesOfString("tmb", withString: "pro")
            case .Thumbnail:
                break
        }
        
        var url = NSURL(string: uri)
        var data = NSData(contentsOfURL: url)
        return UIImage(data: data)
    }
}
