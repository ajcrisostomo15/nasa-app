//
//  APODDatesParam.swift
//  NASA App
//
//  Created by Allen Jeffrey Crisostomo on 4/5/23.
//

import ObjectMapper

class APODSetDatesParam: Mappable {
    var startDate: String = ""
    var endDate: String = ""
    var key = apiKey
    
    init(startDate: String, endDate: String) {
        self.startDate = startDate
        self.endDate = endDate
    }
    
    required init?(map: ObjectMapper.Map) {
        
    }
    
    func mapping(map: ObjectMapper.Map) {
        startDate <- map["start_date"]
        endDate <- map["end_date"]
        key <- map["api_key"]
    }
}
