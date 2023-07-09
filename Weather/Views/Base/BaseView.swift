//
//  BaseView.swift
//  Weather
//
//  Created by Evgeniy Nosko on 7.07.23.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {}
}
