//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Evgeniy Nosko on 7.07.23.
//

import Foundation
import UIKit
import Combine
import CoreLocation

protocol WeatherViewModelProtocol {
    func bind(_ view: WeatherViewProtocol)
    func getWeatherParameters(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    func setBackgroundImage() -> UIImage
    
    func numberOfSecions() -> Int
    func weatherCollectionCellStateModel(at index: Int) -> WeatherCollectionCellStateModel
    func weatherCellStateModel(at index: Int) -> WeatherCellStateModel
    func informationCellStateModel(at index: Int) -> InformationCellStateModel
    func descriptionCellStateModel(at index: Int) -> DescriptionCellStateModel
    
    var cityValue: String { get }
    var currentDegreesValue: String { get }
    var weatherConditionValue: String { get }
    var highTemperatureValue: String { get }
    var minTemperatureValue: String { get }
}

class WeatherViewModel: WeatherViewModelProtocol {
    private let apiService: WeatherAPIServiceProtocol
    private var weather: WeatherData?
    
    private let locationManager = CLLocationManager()
    private var latitude: CLLocationDegrees?
    private var longitude: CLLocationDegrees?
    
    private let days = 3
    
    private var subscriptions: Set<AnyCancellable>
    
    private weak var view: WeatherViewProtocol?
    
    var cityValue: String {
        weather?.location.name ?? ""
    }
    
    var currentDegreesValue: String {
        String(Int(weather?.current.tempC ?? 0)) + "°"
    }
    
    var weatherConditionValue: String {
        weather?.current.condition.text ?? ""
    }
    
    var highTemperatureValue: String {
        "H:\(String(Int(weather?.forecast.forecastday.first?.day.maxtempC ?? 0)) + "°")"
    }
    
    var minTemperatureValue: String {
        "L:\(String(Int(weather?.forecast.forecastday.first?.day.mintempC ?? 0)) + "°")"
    }
    
    init(apiService: WeatherAPIServiceProtocol) {
        self.apiService = apiService
        subscriptions = Set<AnyCancellable>()
    }
    
    func bind(_ view: WeatherViewProtocol) {
        self.view = view
        NetworkMonitor.shared.startMonitoring()
    }
    
    private func getWeather() {
        self.view?.displayLoading(true)
        apiService
            .getWeather(latitude: latitude ?? 0, longitude: longitude ?? 0, days: days)
            .subscribe(onValue: { [weak self] weather in
                guard let self = self else { return }
                self.weather = weather
                self.view?.displayLoading(false)
                self.view?.update()
                NetworkMonitor().stopMonitoring()
            }, onFailure: { [weak self] error in
                self?.view?.displayLoading(false)
                if !NetworkMonitor().isReachable {
                    self?.view?.presentErrorConnection()
                } else {
                    self?.view?.presentError(error)
                }
                NetworkMonitor().stopMonitoring()
            })
            .store(in: &subscriptions)
    }
    
    func getWeatherParameters(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        getWeather()
    }
    
    func numberOfSecions() -> Int {
        return WeatherTableViewSection.numberOfSection
    }
    
    func weatherCollectionCellStateModel(at index: Int) -> WeatherCollectionCellStateModel {
        var temperatureValue: String?
        var timeValue: String?
        var humidityValue: String?
        var iconImage: UIImage?
        
        if let weatherModel = weather {
            let hourlyModel = weatherModel.forecast.forecastday.first?.hour[index]
            let time = hourlyModel?.time
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let date = dateFormatter.date(from:time ?? "")!
            let hourModel = date.timeIntervalSince1970
            let hourForDate = Date(timeIntervalSince1970: Double(hourModel)).getHourForDate()
            
            iconImage = setIconImage(weatherCondition: hourlyModel?.condition.text ?? "")
            temperatureValue = String(Int(hourlyModel?.tempC ?? 0)) + "°"
            timeValue = hourForDate
            humidityValue = String(hourlyModel?.humidity ?? 0) + " %"
        }
        
        return WeatherCollectionCellStateModel(
            temperature: temperatureValue ?? "",
            time: timeValue ?? "",
            humidity: humidityValue ?? "",
            iconImage: iconImage ?? UIImage()
        )
    }
    
    func weatherCellStateModel(at index: Int) -> WeatherCellStateModel {
        var dayValue: String?
        var highTemperatureValue: String?
        var minTemperatureValue: String?
        var humidityValue: String?
        var iconImage: UIImage?
        
        if let weatherModel =  weather {
            let dailyModel = weatherModel.forecast.forecastday[index]
            let daily = dailyModel.date
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let day = dateFormatter.date(from: daily)!
            let dayModel = day.timeIntervalSince1970
            
            dayValue = Date(timeIntervalSince1970: Double(dayModel)).getDayForDate()
            highTemperatureValue = String(Int(dailyModel.day.maxtempC)) + "°"
            minTemperatureValue = String(Int(dailyModel.day.mintempC)) + "°"
            humidityValue = String(dailyModel.day.avghumidity) + " %"
            iconImage = setIconImage(weatherCondition: dailyModel.day.condition.text)
        }
        
        return WeatherCellStateModel(
            day: dayValue ?? "",
            highTemperature: highTemperatureValue ?? "",
            minTemperature: minTemperatureValue ?? "",
            humidity: humidityValue ?? "",
            iconImage: iconImage ?? UIImage()
        )
    }
    
    func informationCellStateModel(at index: Int) -> InformationCellStateModel {
        return InformationCellStateModel(title: "Additional information")
    }
    
    func descriptionCellStateModel(at index: Int) -> DescriptionCellStateModel {
        var titleValue: String?
        var descriptionValue: String?
        var iconImage: UIImage?
        
        let descriptionWeather = DescriptionWeather.allCases[index]
        if let weatherModel = weather {
            switch descriptionWeather {
            case .humidity:
                titleValue = descriptionWeather.rawValue
                descriptionValue = String(Int(weatherModel.current.humidity)) + " %"
                iconImage = Asset.humidity.image
            case .wind:
                titleValue = descriptionWeather.rawValue
                descriptionValue = String(Int(weatherModel.current.windKph * 1000 / 3600 )) + " m/s"
                iconImage = Asset.wind.image
            case .feelsLike:
                titleValue = descriptionWeather.rawValue
                descriptionValue = String(Int(weatherModel.current.feelslikeC)) + "°"
                iconImage = Asset.feelsLike.image
            case .pressure:
                titleValue = descriptionWeather.rawValue
                descriptionValue = String(Int(Double(weatherModel.current.pressureMB) / 133.332 * 100)) + " mm Hg"
                iconImage = Asset.pressure.image
            case .visibility:
                titleValue = descriptionWeather.rawValue
                descriptionValue = String(Int(weatherModel.current.visKM)) + " km"
                iconImage = Asset.visibility.image
            case .uvIndex:
                titleValue = descriptionWeather.rawValue
                descriptionValue = String(Int(weatherModel.current.uv))
                iconImage = Asset.uvIndex.image
            }
        }
        
        return DescriptionCellStateModel(
            title: titleValue ?? "",
            description: descriptionValue ?? "",
            iconImage: iconImage ?? UIImage()
        )
    }
    
    func setBackgroundImage() -> UIImage {
        let weatherCondition = weather?.current.condition.text
        switch weatherCondition {
        case "Sunny", "Clear":
            return Asset.sunnyBackground.image
        case "Partly cloudy":
            return Asset.cloudyBackground.image
        case "Overcast", "Cloudy", "Patchy rain possible":
            return Asset.moreCloudyBackground.image
        case "Rainy", "Light rain", "Light rain shower", "Moderate rain", "Light drizzle", "Patchy light drizzle", "Patchy light rain":
            return Asset.rainyBackground.image
        default: return Asset.cloudyBackground.image
        }
    }
    
    private func setIconImage(weatherCondition: String) -> UIImage {
        switch weatherCondition {
        case "Sunny", "Clear":
            return Asset.sun.image
        case "Partly cloudy":
            return Asset.sunCloud.image
        case "Overcast", "Cloudy", "Patchy rain possible":
            return Asset.cloud.image
        case "Rainy", "Light rain", "Light rain shower", "Moderate rain", "Light drizzle", "Patchy light drizzle", "Patchy light rain":
            return Asset.rain.image
        default: return Asset.sunCloud.image
        }
    }
}
