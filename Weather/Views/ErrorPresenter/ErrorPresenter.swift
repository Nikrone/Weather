//
//  ErrorPresenter.swift
//  Weather
//
//  Created by Evgeniy Nosko on 7.07.23.
//

import UIKit

protocol ErrorPresenterProtocol {
    func presentError(_ error: Error)
    func presentErrorConnection()
}

extension ErrorPresenterProtocol where Self: UIViewController {
    func presentError(_ error: Error) {
        let alertController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func presentErrorConnection() {
        let alertController = UIAlertController(
            title: "Error",
            message: "No connection",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }

}
