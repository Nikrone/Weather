//
//  InformationCell.swift
//  Weather
//
//  Created by Evgeniy Nosko on 8.07.23.
//

import UIKit
import SnapKit

struct InformationCellStateModel {
    let title: String
}

class InformationCell: UITableViewCell {
    static let identifier = "InformationCell"
    
    private let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with stateModel: InformationCellStateModel) {
        titleLabel.text = stateModel.title
    }
}

private extension InformationCell {
    func initialize() {
        contentView.addSubview(titleLabel)
        titleLabel.font = .systemFont(ofSize: 24)
        titleLabel.textColor = .white
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(6)
            make.left.equalToSuperview().inset(10)
        }
    }
}
