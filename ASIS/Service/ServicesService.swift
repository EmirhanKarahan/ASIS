
import Foundation

// MARK: - Routes
struct Routes: Codable {
    let lastUpdated: Int?
    let services: [Service]?

    enum CodingKeys: String, CodingKey {
        case lastUpdated
        case services
    }
}

// MARK: - Service
struct Service: Codable {
    let name, serviceDescription, serviceType: String?
    let routes: [Route]?

    enum CodingKeys: String, CodingKey {
        case name
        case serviceDescription
        case serviceType
        case routes
    }
}

// MARK: - Route
struct Route: Codable {
    let destination: String?
    let points: [Point]?
    let stops: [Int]?
}

// MARK: - Point
struct Point: Codable {
    let stopID: Int?
    let latitude, longitude: Double?

    enum CodingKeys: String, CodingKey {
        case stopID
        case latitude, longitude
    }
}
