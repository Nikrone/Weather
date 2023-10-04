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
        
        if let weatherModel = weather {
            switch index {
            case 0:
                titleValue = descriptionArray[index]
                descriptionValue = String(Int(weatherModel.current.humidity)) + " %"
                iconImage = Asset.humidity.image
            case 1:
                titleValue = descriptionArray[index]
                descriptionValue = String(Int(weatherModel.current.windKph * 1000 / 3600 )) + " m/s"
                iconImage = Asset.wind.image
            case 2:
                titleValue = descriptionArray[index]
                descriptionValue = String(Int(weatherModel.current.feelslikeC)) + "°"
                iconImage = Asset.feelsLike.image
            case 3:
                titleValue = descriptionArray[index]
                descriptionValue = String(Int(Double(weatherModel.current.pressureMB) / 133.332 * 100)) + " mm Hg"
                iconImage = Asset.pressure.image
            case 4:
                titleValue = descriptionArray[index]
                descriptionValue = String(Int(weatherModel.current.visKM)) + " km"
                iconImage = Asset.visibility.image
            case 5:
                titleValue = descriptionArray[index]
                descriptionValue = String(Int(weatherModel.current.uv))
                iconImage = Asset.uvIndex.image
            default:
                print("default value")
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
        if weatherCondition == "Sunny"
            || weatherCondition == "Clear"  {
            return Asset.sunnyBackground.image
        } else if weatherCondition == "Partly cloudy" {
            return Asset.cloudyBackground.image
        } else if weatherCondition == "Overcast"
                    || weatherCondition == "Cloudy"
                    || weatherCondition == "Patchy rain possible" {
            return Asset.moreCloudyBackground.image
        } else if weatherCondition == "Rainy"
                    || weatherCondition == "Light rain"
                    || weatherCondition == "Light rain shower"
                    || weatherCondition == "Moderate rain"
                    || weatherCondition == "Light drizzle"
                    || weatherCondition == "Patchy light drizzle"
                    || weatherCondition == "Patchy light rain" {
            return Asset.rainyBackground.image
        } else {
            return Asset.cloudyBackground.image
        }
    }
    
    private func setIconImage(weatherCondition: String) -> UIImage {
        if weatherCondition == "Sunny"
            || weatherCondition == "Clear"  {
            return Asset.sun.image
        } else if weatherCondition == "Partly cloudy" {
            return Asset.sunCloud.image
        } else if weatherCondition == "Overcast"
                    || weatherCondition == "Cloudy"
                    || weatherCondition == "Patchy rain possible" {
            return Asset.cloud.image
        } else if weatherCondition == "Rainy"
                    || weatherCondition == "Light rain"
                    || weatherCondition == "Light rain shower"
                    || weatherCondition == "Moderate rain"
                    || weatherCondition == "Light drizzle"
                    || weatherCondition == "Patchy light drizzle"
                    || weatherCondition == "Patchy light rain" {
            return Asset.rain.image
        } else {
            return Asset.sunCloud.image
        }
    }
}
