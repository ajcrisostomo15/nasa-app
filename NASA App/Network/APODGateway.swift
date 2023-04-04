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
    
    func getTodaysData(param: APODParam) -> Single<APODResp> {
        return service.rx.request(.viewToday(param: param)).map(APODResp.self)
    }
}
