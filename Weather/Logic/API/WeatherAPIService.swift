//
//  WeatherAPIService.swift
//  Weather
//
//  Created by Evgeniy Nosko on 7.07.23.
//

import Foundation
import Alamofire
import Combine
import CoreLocation

protocol WeatherAPIServiceProtocol {
    func getWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees, days: Int)-> AnyPublisher<WeatherData, APIError>
}

class WeatherAPIService: BaseAPIService, WeatherAPIServiceProtocol {
    func getWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees, days: Int)-> AnyPublisher<WeatherData, APIError> {
        sessionManager.requestDecodable(
            APIRequest<NoParameters>(
                host: Enviroment.weatherURLPath + "\(latitude),\(longitude)&days=\(days)&aqi=no&alerts=no"
            )
        )
    }
}
