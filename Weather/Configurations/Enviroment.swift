//
//  Enviroment.swift
//  Weather
//
//  Created by Evgeniy Nosko on 7.07.23.
//

import Foundation

enum Enviroment {
    static let apiKey = "1bfdcf4e6e084e949ab100535230410"
    static let weatherURLPath = "http://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q="
}
