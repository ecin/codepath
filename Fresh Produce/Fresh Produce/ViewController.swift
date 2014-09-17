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
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.movieTableView.addSubview(refreshControl)

        // Warm up cache
        Movie.all(onError: {
            TSMessage.showNotificationWithTitle("Network Error", type: TSMessageNotificationType.Error)
        })
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
        var posterURL = NSURL(string: movie.posterURL(size: Movie.ImageSize.Profile))
        cell.posterImageView?.setImageWithURL(posterURL)
        cell.yearLabel?.text = movie.year()
        cell.ratingLabel?.text = String(movie.rating())
        cell.synopsisLabel?.text = movie.synopsis()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("details") as MovieDetailsViewController
        let movie = Movie.get(indexPath.row)
        detailsViewController.movie = movie
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func refresh(sender: AnyObject) {
        Movie.refresh()
        refreshControl.endRefreshing()
    }
}

