//
//  APIRequest.swift
//  Weather
//
//  Created by Evgeniy Nosko on 7.07.23.
//

import Foundation
import Alamofire

struct APIRequest<ParametersType: Encodable>: URLRequestConvertible {
    let host: String?
    let path: String?
    let method: HTTPMethod
    let parameters: ParametersType?
    let parametersEncoder: ParameterEncoder?
    let headers: HTTPHeaders?
    
    init(
        host: String? = nil,
        path: String? = nil,
        method: HTTPMethod = .get,
        parameters: ParametersType? = nil,
        parametersEncoder: ParameterEncoder? = nil,
        headers: HTTPHeaders? = nil) {
        
        self.host = host
        self.path = path
        self.method = method
        self.parameters = parameters
        self.parametersEncoder = parametersEncoder
        self.headers = headers
    }
    
    func asURLRequest() throws -> URLRequest {
        let urlString: String = host?.appendingPathComponent(path ?? "") ?? ""
        guard let url = URL(string: urlString) else {
            throw BasicError("Invalid url: \(urlString)")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.name) }
        
        if let parameters = parameters, let encoder = parametersEncoder {
            request = try encoder.encode(parameters, into: request)
        }
        return request
    }
}

enum NoParameters: Encodable {
    func encode(to encoder: Encoder) throws { }
}
