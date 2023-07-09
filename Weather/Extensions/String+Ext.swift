//
//  String+Ext.swift
//  Weather
//
//  Created by Evgeniy Nosko on 7.07.23.
//

import Foundation

extension String {
    func appendingPathComponent(_ component: String) -> String {
        return self.appending("/").appending(component)
    }
}
