//
//  StopToStopTimetableService.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 27.07.2022.
//

import Foundation
import Alamofire

protocol IStopToStopTimetableService {
    func fetchStopToStopTimetableJourneys(startStopID:Int, finalStopID:Int, response: @escaping ([Journey]?) -> Void)
}

struct StopToStopTimetableService: IStopToStopTimetableService{
    
    func fetchStopToStopTimetableJourneys(startStopID:Int, finalStopID:Int, response: @escaping ([Journey]?) -> Void) {
        AF.request(EdinburgTransportationEndPoint.stopToStopTimetablesPath(startStopID: startStopID, finishStopID: finalStopID)).responseDecodable(of: StopToStopTimetablesResult.self) {
            (model) in
            guard let data = model.value else {
                response(nil)
                return
            }
            response(data.journeys)
        }
    }

    
}
