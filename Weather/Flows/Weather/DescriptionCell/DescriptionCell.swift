//
//  DescriptionCell.swift
//  Weather
//
//  Created by Evgeniy Nosko on 8.07.23.
//

import UIKit
import SnapKit

struct DescriptionCellStateModel {
    let title: String
    let description: String
    let iconImage: UIImage
}

class DescriptionCell: UITableViewCell {
    static let identifier = "DescriptionCell"
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let iconImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with stateModel: DescriptionCellStateModel) {
        titleLabel.text = stateModel.title
        descriptionLabel.text = stateModel.description
        iconImageView.image = stateModel.iconImage
    }
}

private extension DescriptionCell {
    func initialize() {
        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.font = .systemFont(ofSize: 15)
        titleLabel.textColor = .lightGray
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImageView).inset(26)
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.font = .systemFont(ofSize: 26)
        descriptionLabel.textColor = .white
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(10)
        }
    }
}
