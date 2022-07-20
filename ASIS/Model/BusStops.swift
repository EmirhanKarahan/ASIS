import Foundation

// MARK: - BusStops
struct BusStops: Codable {
    let lastUpdated: Int?
    let stops: [Stop]?
    
    enum CodingKeys: String, CodingKey {
        case lastUpdated
        case stops
    }
}

// MARK: - Stop
struct Stop: Codable {
    let stopID: Int?
    let atcoCode, name: String?
    let identifier: String?
    let locality: String?
    let orientation: Int?
    let direction: String?
    let latitude, longitude: Double?
    let serviceType: String?
    let destinations, services: [String]?
    let atcoLatitude, atcoLongitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case stopID
        case atcoCode
        case name, identifier, locality, orientation, direction, latitude, longitude
        case serviceType
        case destinations, services
        case atcoLatitude
        case atcoLongitude
    }
}
