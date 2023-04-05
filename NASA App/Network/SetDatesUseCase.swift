//
//  SetDatesUseCase.swift
//  NASA App
//
//  Created by Allen Jeffrey Crisostomo on 4/5/23.
//

import RxSwift

class SetDatesUseCase {
    private let gateWay: APODGateway!
    
    init(gateWay: APODGateway) {
        self.gateWay = gateWay
    }
    
    func execute(param: APODSetDatesParam) -> Observable<[APODResp]> {
        return gateWay.getSetDatesData(param: param)
    }
}
