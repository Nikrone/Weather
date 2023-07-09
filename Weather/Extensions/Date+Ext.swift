//
//  Date+Ext.swift
//  Weather
//
//  Created by Evgeniy Nosko on 7.07.23.
//

import Foundation

extension Date {
    func getTimeForDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    func getHourForDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter.string(from: self)
    }
    
    func getDayForDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
}
