//
//  BaseController.swift
//  Weather
//
//  Created by Evgeniy Nosko on 7.07.23.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupView()
        localize()
    }
    
    func setupData() {}
    
    func setupView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
    }
    
    func localize() {}
}
