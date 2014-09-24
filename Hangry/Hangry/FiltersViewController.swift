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
        sortBySegmentedControl.selectedSegmentIndex = 1
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
        println(search)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
