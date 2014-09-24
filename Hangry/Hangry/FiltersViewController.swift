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
    @IBOutlet weak var foodCategorySwitch: UISwitch!
    @IBOutlet weak var healthCategorySwitch: UISwitch!
    @IBOutlet weak var petCategorySwitch: UISwitch!
    @IBOutlet weak var foodCategoryLabel: UILabel!
    @IBOutlet weak var healthCategoryLabel: UILabel!
    @IBOutlet weak var petCategoryLabel: UILabel!
    @IBOutlet weak var showCategoriesSwitch: UISwitch!
    
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
        
        showCategoriesSwitch.on = !search.categories.isEmpty
        toggleCategories()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showCategoriesChanged(showCategories: UISwitch) {
        if !showCategories.on {
            search.categories = []
        } else {
            calculateCategories()
        }
        
        toggleCategories()
    }
    
    @IBAction func foodCategoryChanged(sender: UISwitch) {
        calculateCategories()
    }
    
    @IBAction func healthCategoryChanged(sender: AnyObject) {
        calculateCategories()
    }
    
    @IBAction func petsCategoryChanged(sender: UISwitch) {
        calculateCategories()
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
    
    func calculateCategories() {
        search.categories = []
        if foodCategorySwitch.on {
            search.categories.append("food")
        }
        if healthCategorySwitch.on {
            search.categories.append("health")
        }
        if petCategorySwitch.on {
            search.categories.append("pets")
        }
    }
    
    func toggleCategories() {
        // Putting all these switches in their own view would make this a lot easier
        foodCategorySwitch.hidden = !showCategoriesSwitch.on
        healthCategorySwitch.hidden = !showCategoriesSwitch.on
        petCategorySwitch.hidden = !showCategoriesSwitch.on
        foodCategoryLabel.hidden = !showCategoriesSwitch.on
        healthCategoryLabel.hidden = !showCategoriesSwitch.on
        petCategoryLabel.hidden = !showCategoriesSwitch.on
        
        foodCategorySwitch.on = contains(search.categories, "food")
        healthCategorySwitch.on = contains(search.categories, "health")
        petCategorySwitch.on = contains(search.categories, "pets")
    }
}
