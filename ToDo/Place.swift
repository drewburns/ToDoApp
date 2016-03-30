//
//  Place.swift
//  ToDo
//
//  Created by Andrew Burns on 12/28/15.
//  Copyright © 2015 Andrew Burns. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class Place: NSManagedObject {
// Insert code here to add functionality to your managed object subclass



}

extension Place: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
    }
}

