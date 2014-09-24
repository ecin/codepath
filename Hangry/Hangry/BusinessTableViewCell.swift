//
//  BusinessTableViewCell.swift
//  Hangry
//
//  Created by Nelson Crespo on 9/23/14.
//  Copyright (c) 2014 Copypastel. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingsImage: UIImageView!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fromBusiness(business: Business) {
        nameLabel.text = business.name
        profileImageView?.setImageWithURL(business.imageURL)
        descriptionTextView.text = business.description
        reviewCount.text = "\(business.reviewCount!) reviews"
        ratingsImage?.setImageWithURL(business.ratingImageURL)
    }

}
