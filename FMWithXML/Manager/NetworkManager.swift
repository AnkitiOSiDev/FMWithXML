//
//  NetworkManager.swift
//  FMWithXML
//
//  Created by Ankit on 17/01/22.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    func getData(url: URL,completion: @escaping NetworkCompletionHandler) {
        URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
            guard let self = self else { return }
            if let data = data {
                completion(.success(data))
            }else{
                completion(.failure(ApiError.NoData))
            }
            
        }.resume()
    }
}


typealias NetworkCompletionHandler = (Result<Data, Error>) -> Void


enum ApiError : Error {
    case InvalidUrl
    case NoData
}
