//
//  LiveVehicleLocationsService.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 28.06.2022.
//

import Alamofire

protocol ILiveVehicleLocationsService {
    func fetchAllDatas(response:@escaping ([Vehicle]?) -> Void)
    func fetchVehiclesInRoute(service:Service, route:Route, response:@escaping ([Vehicle]?) -> Void)
}

struct LiveVehicleLocationsService: ILiveVehicleLocationsService{

    func fetchAllDatas(response:@escaping ([Vehicle]?) -> Void) {
        AF.request(EdinburgTransportationEndPoint.liveVehicleLocationsPath()).responseDecodable(of: LiveBusLocations.self) {
            (model) in
            guard let data = model.value else {
                response(nil)
                return
            }
            response(data.vehicles)
        }
    }
    
    func fetchVehiclesInRoute(service:Service, route:Route, response:@escaping ([Vehicle]?) -> Void){
        AF.request(EdinburgTransportationEndPoint.liveVehicleLocationsPath()).responseDecodable(of: LiveBusLocations.self) {
            (model) in
            guard let data = model.value else {
                response(nil)
                return
            }
            response(data.vehicles.filter { $0.destination == route.destination && $0.serviceName == service.name })
        }
    }
    
}
