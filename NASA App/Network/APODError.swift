//
//  APODError.swift
//  NASA App
//
//  Created by Allen Jeffrey Crisostomo on 4/5/23.
//

import RxSwift
import Moya
import ObjectMapper

extension ObservableType where Element == Response {
    
    func mapErrors() -> Observable<Element> {
//        return flatMap { resp -> Observable<Element> in
//            if 200 ... 299 ~= resp.statusCode {
//                return Observable.just(resp)
//            }
//
//            if let error = resp.data.toJSON() {
//                let error = Mapper<APODServerErrorResp>().map(error)
//                return Observable.error(error)
//            }
//        }
        return self.filterSuccessfulStatusCodes()
            .catch { e in
                guard let error = e as? MoyaError else {
                    throw e
                }
                
                guard let response = error.response else {
                    throw e
                }
//                guard case .statusCode(let response) = error else {
//                    throw e
//                }

                if response.statusCode == 400 {
                    throw ServiceError.invalidDate(response: response)
                } else {
                    throw e
                }
        }
    }
}

enum ServiceError: Swift.Error {
    case invalidDate(response: Response)
}

extension ServiceError {
    var response: Response? {
        switch self {
        case .invalidDate(let response):
            return response
        }
    }
}

extension ServiceError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .invalidDate(let response):
            if let error = try? response.map(APODServerErrorResp.self) {
                return error.msg
            } else {
                return "Something went wrong"
            }
        }
    }
}
