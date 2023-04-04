//
//  APODParam.swift
//  NASA App
//
//  Created by Allen Jeffrey Crisostomo on 4/4/23.
//

import ObjectMapper

class APODParam: Mappable {
    var date: String = ""
    var key = apiKey
    
    init(date: String) {
        self.date = date
    }
    
    required init?(map: ObjectMapper.Map) {
        
    }
    
    func mapping(map: ObjectMapper.Map) {
        date <- map["date"]
        key <- map["api_key"]
    }
}
