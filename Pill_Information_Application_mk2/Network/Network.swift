//
//  Network.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/11/09.
//

import Foundation
import RxSwift
import Alamofire

enum NetworkError: Error {
    case invalidURL
    case invalidJSON
    case networkError
}

class FastAPINetWork {
    private let session: URLSession
    let api = FastAPI()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
}

class MedicineAPINetwork {
    private let session: URLSession
    let api = MedicineAPI()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getMedicineAPI(query: String) -> Single<Result<MedicineOverview, NetworkError>> {
        print(api.getMedicineAPI(query: query).url)
        guard let url = api.getMedicineAPI(query: query).url else {
            return .just(.failure(.invalidURL))
        }

        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
//        request.setValue(MedicineAPI.apiKey, forHTTPHeaderField: "serviceKey")
        return session.rx.data(request: request as URLRequest)
            .map { data in
                do {
                    let medicineData = try JSONDecoder().decode(MedicineOverview.self, from: data)
                    return .success(medicineData)
                } catch {
                    return .failure(.invalidJSON)
                }
            }
            .catch { _ in
                    .just(.failure(.networkError))
            }
            .asSingle()
        
    }
}

class MedicineInfoAPINetwork {
    private let session: URLSession
    let api = MedicineInfoAPI()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getMedicineInfoAPI(query: String) -> Single<Result<MedicineInfoOverview, NetworkError>> {
        guard let url = api.getMedicineInfoAPI(query: query).url else {
            return .just(.failure(.invalidURL))
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(MedicineInfoAPI.apiKey, forHTTPHeaderField: "serviceKey")
        
        return session.rx.data(request: request as URLRequest)
            .map { data in
                do {
                    let medicineInfoData = try JSONDecoder().decode(MedicineInfoOverview.self, from: data)
                    return .success(medicineInfoData)
                } catch {
                    return .failure(.invalidJSON)
                }
            }
            .catch { _ in
                    .just(.failure(.networkError))
            }
            .asSingle()
    }
}
