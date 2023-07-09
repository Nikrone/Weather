//
//  BasicError.swift
//  Weather
//
//  Created by Evgeniy Nosko on 7.07.23.
//

import Foundation

struct BasicError: LocalizedError {
    private(set) var errorDescription: String?
    
    init(_ errorDescription: String) {
        self.errorDescription = errorDescription
    }
}
