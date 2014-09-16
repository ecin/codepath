//
//  MovieDetailsViewController.swift
//  Fresh Produce
//
//  Created by Nelson Crespo on 9/15/14.
//  Copyright (c) 2014 Copypastel. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    var movie: Movie?
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsTextView.text = movie!.synopsis()
        posterImageView.image = movie!.poster(size: Movie.ImageSize.Original)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
