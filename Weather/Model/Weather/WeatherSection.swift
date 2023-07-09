//
//  WeatherSection.swift
//  Weather
//
//  Created by Evgeniy Nosko on 8.07.23.
//

import UIKit

enum WeatherTableViewSection: Int {
    static let numberOfSection = 3
    
    case daily = 0
    case information = 1
    case description = 2
    
    init?(sectionIndex: Int) {
        guard let section = WeatherTableViewSection(rawValue: sectionIndex) else { return nil }
        self = section
    }
    
    var cellHeight: CGFloat {
        switch self {
        case .daily:
            return CGFloat(60)
        case .information:
            return CGFloat(90)
        case .description:
            return CGFloat(60)
        }
    }
}
