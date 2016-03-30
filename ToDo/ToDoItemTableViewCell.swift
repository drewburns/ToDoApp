//
//  ToDoItemTableViewCell.swift
//  ToDo
//
//  Created by Andrew Burns on 12/28/15.
//  Copyright © 2015 Andrew Burns. All rights reserved.
//

import UIKit
import MapKit

class ToDoItemTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!



    var toDoItem: ToDoItem! {
        didSet{
            titleLabel.text = toDoItem.title
            infoLabel.text = toDoItem.info
            let formatter = NSDateFormatter()
            formatter.timeStyle = .ShortStyle
            dateLabel.text = formatter.stringFromDate(toDoItem.date!)
            
        }
    }
    
    @IBAction func getDirections(sender: AnyObject) {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: (self.toDoItem.place?.coordinate)!, addressDictionary: nil))
        
        mapItem.name = self.toDoItem.place?.title

        //You could also choose: MKLaunchOptionsDirectionsModeWalking
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        
        mapItem.openInMapsWithLaunchOptions(launchOptions)
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
