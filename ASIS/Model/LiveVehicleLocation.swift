import Foundation

// MARK: - LiveBusLocations
struct LiveBusLocations: Codable {
    let lastUpdated: Int?
    let vehicles: [Vehicle]?

    enum CodingKeys: String, CodingKey {
        case lastUpdated
        case vehicles
    }
}

// MARK: - Vehicle
struct Vehicle: Codable {
    let vehicleID: String?
    let lastGpsFix: Int?
    let latitude, longitude: Double?
    let speed, heading: Int?
    let serviceName, destination: String?

    enum CodingKeys: String, CodingKey {
        case vehicleID
        case lastGpsFix
        case latitude, longitude, speed, heading
        case serviceName
        case destination
    }
}
