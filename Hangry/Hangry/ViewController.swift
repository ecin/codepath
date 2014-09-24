//
//  ViewController.swift
//  Hangry
//
//  Created by Nelson Crespo on 9/19/14.
//  Copyright (c) 2014 Copypastel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var businessesTableView: UITableView!
    
    var search = Business.Search.getDefaultSearch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var searchBar = UISearchBar()
        searchBar.delegate = self
        
        navigationBar.titleView = searchBar
        search.execute({ (businesses) in self.businessesTableView.reloadData() }, failure: { (error) in print(error) })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(Business.count())
        return Business.count()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = businessesTableView.dequeueReusableCellWithIdentifier("businessTableViewCell") as BusinessTableViewCell
        let business = Business.get(indexPath.row)
        
        if (business != nil) {
            cell.fromBusiness(business!)
        }
        
        return cell
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        search.term = searchBar.text!

        search.execute({ (businesses) in
            self.businessesTableView.reloadData()
            }, failure: { (error) in print(error) })
        
    }
}

