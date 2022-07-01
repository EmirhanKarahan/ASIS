//
//  BusServicesViewModel.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 30.06.2022.
//

import Foundation

protocol IBusServicesViewModel {
    var services:[Service] {get set}
    var busServicesService: IBusServicesService { get }
    var busServicesOutput : BusServicesOutput? { get }
    
    func fetchServices()
    func setDelegate(output: BusServicesOutput)
}

final class BusServicesViewModel:IBusServicesViewModel {
    var busServicesOutput: BusServicesOutput?
    var services: [Service] = []
    let busServicesService: IBusServicesService
    
    init(){
        busServicesService = BusServicesService()
    }
    
    func fetchServices() {
        busServicesService.fetchAllDatas { [weak self] (response) in
            self?.services = response ?? []
            self?.busServicesOutput?.saveDatas(values: self?.services ?? [])
        }
    }
    
    func setDelegate(output: BusServicesOutput) {
        busServicesOutput = output
    }
}


