//
//  APODServerErrorResp.swift
//  NASA App
//
//  Created by Allen Jeffrey Crisostomo on 4/5/23.
//

import Foundation

struct APODServerErrorResp: Decodable {
    var code: Int
    var msg: String
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case msg = "msg"
    }
}
