//
//  Endpoints.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 29.06.2022.
//

enum EdinburgTransportationEndPoint: String {
    case BASE_URL = "https://tfe-opendata.com/api/v1"
    case LIVE_VEHICLE_LOCATIONS_PATH = "/vehicle_locations"
    case STOPS_PATH = "/stops"
    
    static func liveVehicleLocationsPath() -> String {
        return "\(BASE_URL.rawValue)\(LIVE_VEHICLE_LOCATIONS_PATH.rawValue)"
    }
    
    static func stopsPath() -> String {
        return "\(BASE_URL.rawValue)\(STOPS_PATH.rawValue)"
    }

}
