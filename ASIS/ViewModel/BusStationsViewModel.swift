//
//  BusStationsViewModel.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 29.06.2022.
//

import Foundation

protocol IBusStationsViewModel {
    var stops:[Stop] {get set}
    var busStationsService: IBusStationsService { get }
    var busStationsOutPut : BusStationsOutPut? { get }
    
    func fetchStops()
    func setDelegate(output: BusStationsOutPut)
}

final class BusStationsViewModel:IBusStationsViewModel {
    var busStationsOutPut: BusStationsOutPut?
    var stops: [Stop] = []
    let busStationsService: IBusStationsService
    
    init(){
        busStationsService = BusStationsService()
    }
    
    func fetchStops() {
        busStationsService.fetchAllDatas { [weak self] (response) in
            self?.stops = response ?? []
            self?.busStationsOutPut?.saveDatas(values: self?.stops ?? [])
        }
    }
    
    func setDelegate(output: BusStationsOutPut) {
        busStationsOutPut = output
    }
}

