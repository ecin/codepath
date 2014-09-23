//
//  MovieTableViewCell.swift
//  Fresh Produce
//
//  Created by Nelson Crespo on 9/14/14.
//  Copyright (c) 2014 Copypastel. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UITextView!
    @IBOutlet weak var loadingActivityIndicatorView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fromMovie(movie: Movie) {
        self.titleLabel?.text = movie.title()
        var posterURL = NSURL(string: movie.posterURL(size: Movie.ImageSize.Profile))
        self.posterImageView?.setImageWithURL(posterURL)
        self.yearLabel?.text = movie.year()
        self.ratingLabel?.text = String(movie.rating())
        self.synopsisLabel?.text = movie.synopsis()
    }

}
