//
//  BusAnnotation.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 8.07.2022.


import Foundation
import MapKit

final class BusAnnotation: NSObject, MKAnnotation{
    var vehicleID: String
    var title:String?
    @objc dynamic var angle:Int
    @objc dynamic var coordinate: CLLocationCoordinate2D
    init(coordinate: CLLocationCoordinate2D, vehicleID:String, angle:Int) {
        self.coordinate = coordinate
        self.vehicleID = vehicleID
        self.angle = angle
        self.title = "bus"
        super.init()
    }
}
