//
//  SessionManager.swift
//  Weather
//
//  Created by Evgeniy Nosko on 7.07.23.
//

import Foundation
import Alamofire
import Combine

protocol SessionManagerProtocol {
    func requestDecodable<ResultType: Decodable>(_ request: URLRequestConvertible) -> AnyPublisher<ResultType, APIError>
}

class SessionManager: SessionManagerProtocol {
    private let session: Session
    private let serializationQueue: DispatchQueue
    
    init(requestInterceptor: RequestInterceptor? = nil) {
        session = Session(interceptor: requestInterceptor)
        serializationQueue = DispatchQueue(label: "SessionManager.SerializationQueue", qos: .userInitiated, attributes: [.concurrent])
    }
    
    // MARK: - Plain
    private func sendRequest(_ request: URLRequestConvertible) -> AnyPublisher<Data?, APIError> {
        Future { fullfill in
            self.session
                .request(request)
                .validate()
                .response(queue: self.serializationQueue, completionHandler: { response in
                    switch response.result {
                    case .success(let data):
                        fullfill(.success(data))
                    case .failure(let error):
                        let apiError = APIError(rootError: error, failedResponse: response.response, responseData: response.data)
                        fullfill(.failure(apiError))
                    }
                })
        }.eraseToAnyPublisher()
    }
    
    func request(_ request: URLRequestConvertible) -> AnyPublisher<Void, APIError> {
        sendRequest(request)
            .map { _ in return () }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func requestData(_ request: URLRequestConvertible) -> AnyPublisher<Data?, APIError> {
        sendRequest(request)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Decodable
    func requestDecodable<ResultType: Decodable>(_ request: URLRequestConvertible) -> AnyPublisher<ResultType, APIError> {
        requestDecodable(request, keypath: nil, decoder: JSONDecoder(), decodedType: ResultType.self)
    }
    
    func requestDecodable<ResultType: Decodable>(_ request: URLRequestConvertible,
                                                 keypath: String?,
                                                 decoder: JSONDecoder,
                                                 decodedType: ResultType.Type) -> AnyPublisher<ResultType, APIError> {
        
        sendRequest(request)
            .tryMap({ data in
                if let data = data {
                    return data
                } else {
                    throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
                }
            })
            .data(at: keypath)
            .decode(type: ResultType.self, decoder: decoder)
            .mapError { $0 as? APIError ?? APIError.other($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
