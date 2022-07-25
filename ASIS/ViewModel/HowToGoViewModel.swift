//
//  HowToGoViewModel.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 22.07.2022.
//

import Foundation

protocol IHowToGoViewModel {
    var stops:[Stop] {get set}
    var busStationsService: IBusStationsService { get }
    var howToGoOutput : HowToGoOutput? { get }
    
    func fetchStops()
    func setDelegate(output: HowToGoOutput)
}

class HowToGoViewModel:IHowToGoViewModel{
    var howToGoOutput: HowToGoOutput?
    var stops: [Stop] = []
    let busStationsService: IBusStationsService
    
    init(){
        busStationsService = BusStationsService()
    }
    
    func fetchStops() {
        busStationsService.fetchAllDatas { [weak self] (response) in
            self?.stops = response ?? []
            self?.howToGoOutput?.saveStops(values: self?.stops ?? [])
        }
    }
    
    func setDelegate(output: HowToGoOutput) {
        howToGoOutput = output
    }
    
    
}
