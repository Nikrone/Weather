//
//  AppFlowRouter.swift
//  Weather
//
//  Created by Evgeniy Nosko on 7.07.23.
//

import UIKit

protocol AppFlowRouterProtocol {
    func openAppLoadingScreen()
    func openWeather()
}

class AppFlowRouter: AppFlowRouterProtocol {
    private let window: UIWindow
    private let appManager: AppManagerProtocol
    
    init(window: UIWindow, appManager: AppManagerProtocol) {
        self.window = window
        self.appManager = appManager
    }
    
    func openAppLoadingScreen() {
        let controller = StoryboardScene.AppLoading.appLoadingController.instantiate()
        changeRootController(to: controller, animated: false)
    }
    
    func openWeather() {
        let controller = StoryboardScene.Weather.weatherController.instantiate()
        controller.viewModel = WeatherViewModel(
            apiService: WeatherAPIService(sessionManager: appManager.sessionManager)
        )
        let navigationController = BaseNavigationController(rootViewController: controller)
        changeRootController(to: navigationController)
    }
    
    private func changeRootController(to newController: UIViewController, animated: Bool = true) {
        if animated {
            UIView.transition(with: window, duration: 0.35, options: .transitionCrossDissolve, animations: {
                let animationsState = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                self.window.rootViewController = newController
                UIView.setAnimationsEnabled(animationsState)
            }, completion: nil)
        } else {
            window.rootViewController = newController
        }
    }
}
