//
//  Enviroment.swift
//  Weather
//
//  Created by Evgeniy Nosko on 7.07.23.
//

import Foundation

enum Enviroment {
    static let apiKey = "4c11dec96f1b49c6b07152249232906"
    static let weatherURLPath = "http://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q="
}
