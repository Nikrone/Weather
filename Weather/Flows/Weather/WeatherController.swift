//
//  WeatherController.swift
//  Weather
//
//  Created by Evgeniy Nosko on 7.07.23.
//

import UIKit
import SnapKit
import CoreLocation

protocol WeatherViewProtocol: AnyObject, ErrorPresenterProtocol {
    func displayLoading(_ enabled: Bool)
    func update()
}

class WeatherController: BaseViewController {
    private let locationManager = CLLocationManager()
    
    private let loadingIndicator = UIActivityIndicatorView()
    private var tableView = UITableView()
    private let generalView = UIView()
    private var collectionView: UICollectionView!
    private var imageView = UIImageView()
    private let cityLabel = UILabel()
    private let currentDegreesLabel = UILabel()
    private let weatherConditionLabel = UILabel()
    private let highTemperatureLabel = UILabel()
    private let minTemperatureLabel = UILabel()
    
    var viewModel: WeatherViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(self)
        initialize()
        setupLocationManager()
    }
    
    override func setupView() {
        super.setupView()
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.isHidden = true
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

private extension WeatherController {
    func initialize() {
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(generalView)
        generalView.backgroundColor = .clear
        generalView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2.5)
        }
        
        view.addSubview(cityLabel)
        cityLabel.font = .systemFont(ofSize: 37)
        cityLabel.textColor = .white
        cityLabel.snp.makeConstraints { make in
            make.centerX.equalTo(generalView)
            make.top.equalTo(generalView).inset(130)
        }
        
        view.addSubview(currentDegreesLabel)
        currentDegreesLabel.font = .systemFont(ofSize: 102)
        currentDegreesLabel.textColor = .white
        currentDegreesLabel.snp.makeConstraints { make in
            make.centerX.equalTo(cityLabel)
            make.top.equalTo(cityLabel).inset(36)
        }
        
        view.addSubview(weatherConditionLabel)
        weatherConditionLabel.font = .systemFont(ofSize: 24)
        weatherConditionLabel.textColor = .white
        weatherConditionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(currentDegreesLabel)
            make.top.equalTo(currentDegreesLabel).inset(110)
        }
        
        view.addSubview(highTemperatureLabel)
        highTemperatureLabel.font = .systemFont(ofSize: 21)
        highTemperatureLabel.textColor = .white
        highTemperatureLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(132)
            make.top.equalTo(weatherConditionLabel).inset(30)
        }
        
        view.addSubview(minTemperatureLabel)
        minTemperatureLabel.font = .systemFont(ofSize: 21)
        minTemperatureLabel.textColor = .white
        minTemperatureLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(132)
            make.top.equalTo(weatherConditionLabel).inset(30)
        }
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = AppColor.darkGray.withAlphaComponent(0.5)
        collectionView.layer.cornerRadius = 14
        collectionView.showsHorizontalScrollIndicator = false
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(generalView).inset(380)
            make.height.equalTo(100)
        }
        collectionView.register(WeatherCollectionCell.self, forCellWithReuseIdentifier: WeatherCollectionCell.identifier)
        collectionView.dataSource = self
        
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 14
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(collectionView).inset(140)
            make.height.equalTo(340)
            make.bottom.equalToSuperview().inset(20)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.showsVerticalScrollIndicator = false
        
        tableView.register(WeatherCell.self, forCellReuseIdentifier: WeatherCell.identifier)
        tableView.register(InformationCell.self, forCellReuseIdentifier: InformationCell.identifier)
        tableView.register(DescriptionCell.self, forCellReuseIdentifier: DescriptionCell.identifier)
        
    }
}

// MARK: - WeatherViewProtocol
extension WeatherController: WeatherViewProtocol {
    func displayLoading(_ enabled: Bool) {
        if enabled {
            tableView.alpha = 0
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.isHidden = true
            UIView.animate(withDuration: 0.25) {
                self.tableView.alpha = 1
            }
        }
    }
    
    func update() {
        cityLabel.text = viewModel.cityValue
        currentDegreesLabel.text = viewModel.currentDegreesValue
        weatherConditionLabel.text = viewModel.weatherConditionValue
        highTemperatureLabel.text = viewModel.highTemperatureValue
        minTemperatureLabel.text = viewModel.minTemperatureValue
        imageView.image = viewModel.setBackgroundImage()
        
        tableView.reloadData()
        collectionView.reloadData()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension WeatherController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSecions()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = WeatherTableViewSection(sectionIndex: section) else { return 0 }
        switch section {
        case .daily:
            return 7
        case .information:
            return 1
        case .description:
            return descriptionArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = WeatherTableViewSection(sectionIndex: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .daily:
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.identifier, for: indexPath) as! WeatherCell
            let stateModel = viewModel.weatherCellStateModel(at: indexPath.row)
            cell.selectionStyle = .none
            cell.backgroundColor = AppColor.darkGray.withAlphaComponent(0.5)
            cell.update(with: stateModel)
            return cell
            
        case .information:
            let cell = tableView.dequeueReusableCell(withIdentifier: InformationCell.identifier, for: indexPath) as! InformationCell
            let stateModel = viewModel.informationCellStateModel(at: indexPath.row)
            cell.selectionStyle = .none
            cell.backgroundColor = AppColor.darkGray.withAlphaComponent(0.5)
            cell.update(with: stateModel)
            return cell
            
        case .description:
            let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionCell.identifier, for: indexPath) as! DescriptionCell
            let stateModel = viewModel.descriptionCellStateModel(at: indexPath.row)
            cell.selectionStyle = .none
            cell.backgroundColor = AppColor.darkGray.withAlphaComponent(0.5)
            cell.update(with: stateModel)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = WeatherTableViewSection(sectionIndex: indexPath.section) else { return CGFloat() }
        switch section {
        case .daily:
            return section.cellHeight
        case .information:
            return section.cellHeight
        case .description:
            return section.cellHeight
        }
    }
}

extension WeatherController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionCell.identifier, for: indexPath) as! WeatherCollectionCell
        let stateModel = viewModel.weatherCollectionCellStateModel(at: indexPath.item)
        cell.update(with: stateModel)
        return cell
    }
}

// MARK: - CLLocationManagerDelegate
extension WeatherController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        viewModel.getWeatherParameters(manager, didUpdateLocations: locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Can't get location", error)
    }
}
