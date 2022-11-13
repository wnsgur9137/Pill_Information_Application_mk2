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
        print(api.getMedicineAPI(query: query).url as Any)
                guard let url = api.getMedicineAPI(query: query).url else {
                    return .just(.failure(.invalidURL))
                }
        
                let request = NSMutableURLRequest(url: url)
                request.httpMethod = "GET"
//                request.setValue(MedicineAPI.apiKey, forHTTPHeaderField: "serviceKey")
                return session.rx.data(request: request as URLRequest)
                    .map { data in
                        do {
                            print(data)
                            let medicineData = try JSONDecoder().decode(MedicineOverview.self, from: data)
                            return .success(medicineData)
                        } catch {
                            print(error)
                            return .failure(.invalidJSON)
                        }
                    }
                    .catch { _ in
                            .just(.failure(.networkError))
                    }
                    .asSingle()
        
//        let url = "\(MedicineAPI.scheme)://\(MedicineAPI.host+MedicineAPI.path)"
//
//        let param = [
//            "serviceKey": MedicineAPI.apiKey,
//            "item_name": query,
//            "type": "json"
//        ]
//
//        print(url)
//        print(param)
//
//        return Observable.create { obsarver -> Disposable in
//            AF.request(url, method: .get, parameters: param)
//                .response(completionHandler: { response in
//                    switch response.result {
//                    case .success(let data):
//                        do {
//                            let result = try JSONDecoder().decode(MedicineOverview.self, from: data!)
//                            print("result: \(result)")
//                            return obsarver.onNext(.success(result))
//                        } catch {
//                            return obsarver.onNext(.failure(.invalidJSON))
//                        }
//                    case .failure(let error):
//                        print(error)
//                        return obsarver.onNext(.failure(.networkError))
//                    }
//                })
//            return Disposables.create()
//        }
        
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
