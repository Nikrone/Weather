//
//  BaseRouter.swift
//  Weather
//
//  Created by Evgeniy Nosko on 7.07.23.
//

import UIKit

class BaseRouter {
    private(set) weak var hostController: UIViewController?
    private(set) var appManager: AppManagerProtocol
    
    init(hostController: UIViewController, appManager: AppManagerProtocol) {
        self.hostController = hostController
        self.appManager = appManager
    }
}
