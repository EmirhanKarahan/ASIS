//
//  BusServicesService.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 30.06.2022.
//

import Foundation
import Alamofire

protocol IBusServicesService {
    func fetchAllDatas(response:@escaping ([Service]?) -> Void)
}

struct BusServicesService: IBusServicesService{
    
    func fetchAllDatas(response: @escaping ([Service]?) -> Void) {
        AF.request(EdinburgTransportationEndPoint.busServicesPath()).responseDecodable(of: BusServices.self) {
            (model) in
            guard let data = model.value else {
                response(nil)
                return
            }
            response(data.services)
        }
    }
}
