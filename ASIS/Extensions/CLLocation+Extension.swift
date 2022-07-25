//
//  CLLocation+Extension.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 25.07.2022.
//

import Foundation
import CoreLocation


extension CLLocation {

    func nearestCoordinate(locations: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D? {
        let sorted = locations.map({return CLLocation(latitude: $0.latitude, longitude: $0.longitude)})
                              .sorted(by: { $0.distance(from: self) < $1.distance(from: self)})
    
        return sorted[0].coordinate
    }

}

