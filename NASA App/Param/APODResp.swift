//
//  APODResp.swift
//  NASA App
//
//  Created by Allen Jeffrey Crisostomo on 4/4/23.
//

import Foundation

struct APODResp: Decodable {
    var date: String
    var explanation: String
    var title: String
    var imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case explanation = "explanation"
        case title = "title"
        case imageUrl = "url"
    }
}
