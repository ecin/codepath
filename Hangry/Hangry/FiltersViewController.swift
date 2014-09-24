//
//  FiltersViewController.swift
//  Hangry
//
//  Created by Nelson Crespo on 9/23/14.
//  Copyright (c) 2014 Copypastel. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {

    var search = Business.Search.getDefaultSearch()
    
    @IBOutlet weak var sortBySegmentedControl: UISegmentedControl!
    @IBOutlet weak var hasDealsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hasDealsSwitch.on = search.hasDeals
        
        // Must be a more elegant way of doing this
        switch search.sortBy {
        case Business.Search.Sort.Matched:
            sortBySegmentedControl.selectedSegmentIndex = 0
        case Business.Search.Sort.Distance:
            sortBySegmentedControl.selectedSegmentIndex = 1
        case Business.Search.Sort.Rating:
            sortBySegmentedControl.selectedSegmentIndex = 2
        default:
            sortBySegmentedControl.selectedSegmentIndex = 0
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sortByChanged(sortBy: UISegmentedControl) {
        var index = sortBy.selectedSegmentIndex
        
        // Good thing we're not localizing this
        switch sortBy.titleForSegmentAtIndex(index)! {
        case "Distance":
            search.sortBy = Business.Search.Sort.Distance
        case "Rating":
            search.sortBy = Business.Search.Sort.Rating
        default:
            search.sortBy = Business.Search.Sort.Matched
        }
    }
    
    @IBAction func hasDealsChanged(hasDeals: UISwitch) {
        search.hasDeals = hasDeals.on
    }
}
