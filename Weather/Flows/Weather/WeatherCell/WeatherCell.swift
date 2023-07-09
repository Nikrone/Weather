//
//  WeatherCell.swift
//  Weather
//
//  Created by Evgeniy Nosko on 8.07.23.
//

import UIKit
import SnapKit

struct WeatherCellStateModel {
    let day: String
    let highTemperature: String
    let minTemperature: String
    let humidity: String
    let iconImage: UIImage
}

class WeatherCell: UITableViewCell {
    static let identifier = "WeatherCell"
    
    private let dayLabel = UILabel()
    private let highTemperatureLabel = UILabel()
    private let lowTemperatureLabel = UILabel()
    private let humidityLabel = UILabel()
    private let iconImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with stateModel: WeatherCellStateModel) {
        dayLabel.text = stateModel.day
        highTemperatureLabel.text = stateModel.highTemperature
        lowTemperatureLabel.text = stateModel.minTemperature
        humidityLabel.text = stateModel.humidity
        iconImageView.image = stateModel.iconImage
    }
}

private extension WeatherCell {
    func initialize() {
        contentView.addSubview(dayLabel)
        dayLabel.font = .systemFont(ofSize: 17)
        dayLabel.textColor = .white
        dayLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(highTemperatureLabel)
        highTemperatureLabel.font = .systemFont(ofSize: 22)
        highTemperatureLabel.textColor = .white
        highTemperatureLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(lowTemperatureLabel)
        lowTemperatureLabel.font = .systemFont(ofSize: 22)
        lowTemperatureLabel.textColor = .systemGray2
        lowTemperatureLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(highTemperatureLabel).inset(50)
        }
        
        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.right.equalTo(lowTemperatureLabel).inset(100)
            make.height.equalTo(32)
        }
        
        contentView.addSubview(humidityLabel)
        humidityLabel.font = .boldSystemFont(ofSize: 10)
        humidityLabel.textColor = AppColor.lightBlue
        humidityLabel.snp.makeConstraints { make in
            make.centerX.equalTo(iconImageView)
            make.top.equalTo(iconImageView).inset(32)
        }
    }
}
