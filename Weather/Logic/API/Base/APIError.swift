//
//  APIError.swift
//  Weather
//
//  Created by Evgeniy Nosko on 7.07.23.
//

import Foundation
import Alamofire

enum APIError: LocalizedError {
    case networkConnectivity(URLError)
    case server(ServerError)
    case other(Error)
    
    init(rootError: Error, failedResponse: HTTPURLResponse?, responseData: Data?) {
        if let data = responseData, let serverError = try? JSONDecoder().decode(ServerError.self, from: data) {
            self = .server(serverError)
        } else if let afError = rootError as? AFError,
                  case .sessionTaskFailed(let nestedError) = afError,
                  let urlError = nestedError as? URLError {
            let code = urlError.code
            if code == .notConnectedToInternet || code == .networkConnectionLost {
                self = .networkConnectivity(urlError)
            } else {
                self = .other(rootError)
            }
        } else {
            self = .other(rootError)
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .networkConnectivity:
            return "Internet connection lost"
        case .server(let serverError):
            return serverError.message
        case .other:
            return "Error"
        }
    }
}

// MARK: - Helpers
extension APIError {
    var isNetworkConnectivity: Bool {
        if case .networkConnectivity = self {
            return true
        } else {
            return false
        }
    }
    
    var isServer: Bool {
        if case .server = self {
            return true
        } else {
            return false
        }
    }
    
    var isOther: Bool {
        if case .other = self {
            return true
        } else {
            return false
        }
    }
}

// MARK: - Server Error

struct ServerError: Codable {
    let message: String
}
