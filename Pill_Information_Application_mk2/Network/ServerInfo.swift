//
//  ServerInfo.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/11/01.
//

import RxSwift
import Alamofire

struct FastAPI {
    static let scheme = "https"
    static let host = "http://127.0.0.1:8000"
    static let path = "/PillInfo"
    
    func getUserInfo(query: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = FastAPI.scheme
        components.host = FastAPI.host
        components.path = FastAPI.path + "getUserInfo"
        
        components.queryItems = [
            URLQueryItem(name: "query", value: query)
        ]
        return components
    }
}
