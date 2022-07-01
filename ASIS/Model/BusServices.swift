// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let busServices = try? newJSONDecoder().decode(BusServices.self, from: jsonData)

import Foundation

// MARK: - BusServices
struct BusServices: Codable {
    let lastUpdated: Int?
    let services: [Service]?

    enum CodingKeys: String, CodingKey {
        case lastUpdated
        case services
    }
}

// MARK: - Service
struct Service: Codable {
    let name, description, serviceType: String?
    let routes: [Route]?

    enum CodingKeys: String, CodingKey {
        case name
        case description
        case serviceType
        case routes
    }
}

// MARK: - Route
struct Route: Codable {
    let destination: String?
    let points: [Point]?
    let stops: [String]?
}

// MARK: - Point
struct Point: Codable {
    let stop_id: String?
    let latitude, longitude: Double?

    enum CodingKeys: String, CodingKey {
        case stop_id
        case latitude, longitude
    }
}
