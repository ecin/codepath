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
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var detailsTextView: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsTextView.text = movie!.synopsis()
        CGSizeMake(detailsTextView.frame.size.width, CGFloat.max)
        var textSize = detailsTextView.sizeThatFits(CGSizeMake(detailsTextView.frame.size.width, CGFloat.max))
        scrollView.contentSize = textSize
        scrollView.sizeToFit()
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
