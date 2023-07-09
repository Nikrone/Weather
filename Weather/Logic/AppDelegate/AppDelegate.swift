//
//  AppDelegate.swift
//  Weather
//
//  Created by Evgeniy Nosko on 7.07.23.
//

import UIKit
import AlamofireNetworkActivityLogger

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var appManager: AppManagerProtocol!
    private var appFlowManager: AppFlowManagerProtocol!
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.makeKeyAndVisible()
        
        appManager = AppManager()
        appFlowManager = AppFlowManager(
            router: AppFlowRouter(window: window, appManager: appManager)
        )
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
        appFlowManager.openAppLoadingScreen()
        return true
    }
}
