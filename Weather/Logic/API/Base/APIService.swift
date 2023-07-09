//
//  APIService.swift
//  Weather
//
//  Created by Evgeniy Nosko on 7.07.23.
//

import Foundation

class BaseAPIService {
    let sessionManager: SessionManagerProtocol
    
    init(sessionManager: SessionManagerProtocol) {
        self.sessionManager = sessionManager
    }
}
