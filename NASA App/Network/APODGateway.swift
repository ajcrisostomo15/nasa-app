//
//  APODGateway.swift
//  NASA App
//
//  Created by Allen Jeffrey Crisostomo on 4/4/23.
//

import RxSwift
import Moya
import ObjectMapper

class APODGateway {
    private let service: NASAService!
    
    init(service: NASAService) {
        self.service = service
    }
    
    func getTodaysData(param: APODParam) -> Observable<APODResp> {
        return service.rx.request(.viewToday(param: param))
            .asObservable().filterSuccessfulStatusAndRedirectCodes().mapErrors()
            .map(APODResp.self)
    }
    
    func getSetDatesData(param: APODSetDatesParam) ->Observable<[APODResp]> {
        return service.rx.request(.setDates(param: param))
            .asObservable().mapErrors()
            .map([APODResp].self)
    }
}
