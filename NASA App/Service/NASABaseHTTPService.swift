//
//  NasaService.swift
//  NASA App
//
//  Created by Allen Jeffrey Crisostomo on 4/4/23.
//

import Moya

public protocol NASABaseHTTPService {}

public extension NASABaseHTTPService {
    func getBaseURL() -> URL {
        if let url = URL(string: "https://api.nasa.gov/") {
            return url
        } else {
            return URL(fileURLWithPath: "")
        }
    }
}
