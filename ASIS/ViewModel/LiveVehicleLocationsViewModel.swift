//
//  LiveVehicleLocationsViewModel.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 28.06.2022.
//

import Foundation

protocol ILiveVehicleLocationsViewModel {
    var vehicles:[Vehicle] {get set}
    var liveVehicleLocationsService: ILiveVehicleLocationsService { get }
    var liveVehicleLocationsOutPut : LiveVehicleLocationsOutPut? { get }
    
    func fetchVehicles()
    func setDelegate(output: LiveVehicleLocationsOutPut)
}

final class LiveVehicleLocationsViewModel:ILiveVehicleLocationsViewModel {
    var liveVehicleLocationsOutPut: LiveVehicleLocationsOutPut?
    var vehicles: [Vehicle] = []
    let liveVehicleLocationsService: ILiveVehicleLocationsService
    
    init(){
        liveVehicleLocationsService = LiveVehicleLocationsService()
    }
    
    @objc func fetchVehicles() {
        liveVehicleLocationsService.fetchAllDatas { [weak self] (response) in
            self?.vehicles = response ?? []
            self?.liveVehicleLocationsOutPut?.saveDatas(values: self?.vehicles ?? [])
        }
    }
    
    func setDelegate(output: LiveVehicleLocationsOutPut) {
        liveVehicleLocationsOutPut = output
    }
}
