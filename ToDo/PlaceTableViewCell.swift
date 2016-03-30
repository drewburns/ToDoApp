//
//  PlaceTableViewCell.swift
//  ToDo
//
//  Created by Andrew Burns on 12/28/15.
//  Copyright © 2015 Andrew Burns. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!

    var place: Place! {
        didSet {
            nameLabel.text = place.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
