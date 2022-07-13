//
//  BusAnnotation.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 8.07.2022.
//

import Foundation
import MapKit

class BusAnnotation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var vehicleID: String
    
    init(coordinate: CLLocationCoordinate2D, vehicleID:String) {
        self.coordinate = coordinate
        self.vehicleID = vehicleID
        super.init()
    }
    
}
