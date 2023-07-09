//
//  AppManager.swift
//  Weather
//
//  Created by Evgeniy Nosko on 7.07.23.
//

import Foundation

protocol AppManagerProtocol {
    var sessionManager: SessionManagerProtocol { get }
}

class AppManager: AppManagerProtocol {
    let sessionManager: SessionManagerProtocol
    
    init() {
        sessionManager = SessionManager(requestInterceptor: nil)
    }
}
