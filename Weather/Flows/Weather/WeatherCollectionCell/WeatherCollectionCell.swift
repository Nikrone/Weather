//
//  WeatherCollectionCell.swift
//  Weather
//
//  Created by Evgeniy Nosko on 7.07.23.
//

import UIKit
import SnapKit

struct WeatherCollectionCellStateModel {
    let temperature: String
    let time: String
    let humidity: String
    let iconImage: UIImage
}

class WeatherCollectionCell: UICollectionViewCell, NibLoadableView {
    static let identifier = "WeatherCollectionCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let temperatureLabel = UILabel()
    private let timeLabel = UILabel()
    private let humidityLabel = UILabel()
    private let imageView = UIImageView()
    
    func update(with stateModel: WeatherCollectionCellStateModel) {
        temperatureLabel.text = stateModel.temperature
        timeLabel.text = stateModel.time
        humidityLabel.text = stateModel.humidity
        imageView.image = stateModel.iconImage
    }
}

private extension WeatherCollectionCell {
    func initialize() {
        contentView.addSubview(timeLabel)
        timeLabel.font = .systemFont(ofSize: 17)
        timeLabel.textColor = .white
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(-20)
            make.left.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel).inset(22)
            make.centerX.equalTo(timeLabel)
        }
        
        contentView.addSubview(humidityLabel)
        humidityLabel.font = .boldSystemFont(ofSize: 10)
        humidityLabel.textColor = AppColor.lightBlue
        humidityLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView).inset(28)
            make.centerX.equalTo(imageView)
        }
        
        contentView.addSubview(temperatureLabel)
        temperatureLabel.font = .systemFont(ofSize: 22)
        temperatureLabel.textColor = .white
        temperatureLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(-20)
            make.centerX.equalTo(imageView)
        }
    }
}
