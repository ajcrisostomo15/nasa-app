//
//  TodayUseCase.swift
//  NASA App
//
//  Created by Allen Jeffrey Crisostomo on 4/4/23.
//

import RxSwift

class TodayUseCase {
    private let gateWay: APODGateway!
    
    init(gateWay: APODGateway) {
        self.gateWay = gateWay
    }
    
    func execute(param: APODParam) -> Observable<APODResp> {
        return gateWay.getTodaysData(param: param)
    }
}
