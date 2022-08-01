//
//  StopToStopTimetablesResult.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 22.07.2022.
//

import Foundation

// MARK: - StopToStopTimetablesResult
struct StopToStopTimetablesResult: Codable {
    let startStopID, finishStopID, date, duration: Int
    let journeys: [Journey]

    enum CodingKeys: String, CodingKey {
        case startStopID = "start_stop_id"
        case finishStopID = "finish_stop_id"
        case date, duration, journeys
    }
}

// MARK: - Journey
struct Journey: Codable {
    let serviceName: String
    let destination: String
    let departures: [Departure]

    enum CodingKeys: String, CodingKey {
        case serviceName = "service_name"
        case destination, departures
    }
}

// MARK: - Departure
struct Departure: Codable {
    let stopID: Int
    let name, time: String
    let timingPoint: Bool

    enum CodingKeys: String, CodingKey {
        case stopID = "stop_id"
        case name, time
        case timingPoint = "timing_point"
    }
}
