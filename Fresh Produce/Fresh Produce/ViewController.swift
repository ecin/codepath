//
//  ViewController.swift
//  Fresh Produce
//
//  Created by Nelson Crespo on 9/14/14.
//  Copyright (c) 2014 Copypastel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var movieTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Warm up cache
        Movie.all()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Hello, couch potato.")
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Movie.count()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCellWithIdentifier("com.copypastel.freshproduce.moviecell") as MovieTableViewCell
        let movie = Movie.get(indexPath.row)
        cell.titleLabel?.text = movie.title()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailsViewController = MovieDetailsViewController(nibName: nil, bundle: nil)
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

