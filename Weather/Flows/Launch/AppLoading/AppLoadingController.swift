//
//  File.swift
//  Weather
//
//  Created by Evgeniy Nosko on 7.07.23.
//

import UIKit
import SnapKit

class AppLoadingController: BaseViewController {
    private let loadingBackgroundImageView = UIImageView()
    private let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}

private extension AppLoadingController {
    func initialize() {
        view.addSubview(loadingBackgroundImageView)
        loadingBackgroundImageView.image = Asset.sunnyBackground.image
        loadingBackgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
