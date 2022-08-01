//
//  HowToGoViewModel.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 22.07.2022.
//

import Foundation

protocol IHowToGoViewModel {
    var stops:[Stop] {get set}
    var services:[Service] {get set}
    var busStationsService: IBusStationsService { get }
    var stopToStopTimetableService: IStopToStopTimetableService { get }
    var busServicesService: IBusServicesService { get }
    var howToGoOutput : HowToGoOutput? { get }
    
    func fetchStops()
    func fetchStopToStopTimetableJourneys(startStopID:Int, finalStopID:Int)
    func setDelegate(output: HowToGoOutput)
}

final class HowToGoViewModel:IHowToGoViewModel {
    var howToGoOutput: HowToGoOutput?
    var stops: [Stop] = []
    var journeys: [Journey] = []
    var services: [Service] = []
    let busStationsService: IBusStationsService
    let busServicesService: IBusServicesService
    let stopToStopTimetableService: IStopToStopTimetableService
    
    init() {
        busStationsService = BusStationsService()
        stopToStopTimetableService = StopToStopTimetableService()
        busServicesService = BusServicesService()
    }
    
     func fetchStops() {
        busStationsService.fetchAllDatas { [weak self] (response) in
            self?.stops = response ?? []
            self?.howToGoOutput?.saveStops(values: self?.stops ?? [])
        }
    }
    
    func fetchStopToStopTimetableJourneys(startStopID:Int, finalStopID:Int) {
        stopToStopTimetableService.fetchStopToStopTimetableJourneys(startStopID: startStopID, finalStopID: finalStopID) { [weak self] (response) in
            self?.journeys = response ?? []
            self?.howToGoOutput?.saveJourneys(values: self?.journeys ?? [])
        }
    }
    
    func setDelegate(output: HowToGoOutput) {
        howToGoOutput = output
    }
    
}
