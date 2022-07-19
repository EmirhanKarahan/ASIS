//
//  BusAnnotation.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 8.07.2022.


import Foundation
import MapKit

final class BusAnnotation: NSObject, MKAnnotation{
    var vehicleID: String
    dynamic var coordinate: CLLocationCoordinate2D
    init(coordinate: CLLocationCoordinate2D, vehicleID:String) {
        self.coordinate = coordinate
        self.vehicleID = vehicleID
        super.init()
    }
}
