//
//  BusStationsService.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 29.06.2022.
//

import Foundation
import Alamofire

protocol IBusStationsService {
    func fetchAllDatas(response:@escaping ([Stop]?) -> Void)
}

struct BusStationsService: IBusStationsService{

    func fetchAllDatas(response:@escaping ([Stop]?) -> Void) {
        AF.request(EdinburgTransportationEndPoint.stopsPath()).responseDecodable(of: BusStops.self) {
            (model) in
            guard let data = model.value else {
                response(nil)
                return
            }
            response(data.stops)
        }
    }
}
