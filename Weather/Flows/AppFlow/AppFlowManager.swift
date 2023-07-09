//
//  AppFlowManager.swift
//  Weather
//
//  Created by Evgeniy Nosko on 7.07.23.
//

import Foundation
import Combine

protocol AppFlowManagerProtocol {
    func openAppLoadingScreen()
}

class AppFlowManager: AppFlowManagerProtocol {
    private let router: AppFlowRouterProtocol
    private var subscriptions: Set<AnyCancellable>
    
    init(router: AppFlowRouterProtocol) {
        self.router = router
        subscriptions = []
    }
        
    func openAppLoadingScreen() {
        router.openAppLoadingScreen()
        router.openWeather()
    }
}
