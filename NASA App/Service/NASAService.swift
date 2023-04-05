//
//  FeedService.swift
//  NASA App
//
//  Created by Allen Jeffrey Crisostomo on 4/4/23.
//

import Moya

class NASAService: MoyaProvider<Service> {
    init(plugins: [PluginType] = [NetworkLoggerPlugin()]) {
        super.init(plugins: plugins)
    }
}

enum Service: NASABaseHTTPService {
    case viewToday(param: APODParam)
    case setDates(param: APODSetDatesParam)
}

extension Service: TargetType {
    var validationType: ValidationType { return .successCodes }
    var task: Moya.Task {
        var encoding: ParameterEncoding = URLEncoding.default
        
        switch method {
        case .post:
            encoding = JSONEncoding.default
        default:
            encoding = URLEncoding.default
        }
        
        switch self {
        case .viewToday(let param):
            return .requestParameters(parameters: param.toJSON(), encoding: encoding)
        case .setDates(let param):
            return .requestParameters(parameters: param.toJSON(), encoding: encoding)
        }
    }
    
    var baseURL: URL {
        return self.getBaseURL()
    }
    
    var path: String {
        switch self {
        case .viewToday,
                .setDates:
            return "planetary/apod"
        }
    }
    
    var method: Method {
        switch self {
        case .viewToday,
                .setDates:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        return [:]
    }
}
