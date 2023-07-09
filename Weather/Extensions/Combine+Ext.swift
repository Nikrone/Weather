//
//  Combine+Ext.swift
//  Weather
//
//  Created by Evgeniy Nosko on 7.07.23.
//

import Foundation
import Combine

extension Publisher {
    func subscribe(onValue: @escaping (Output) -> (), onFailure: ((Failure) -> ())?, onCompleted: (() -> ())? = nil) -> AnyCancellable {
        return sink(receiveCompletion: { (completion) in
            switch completion {
            case.finished:
                onCompleted?()
                break
            case .failure(let error):
                onFailure?(error)
            }
        }, receiveValue: { value in
            onValue(value)
        })
    }
    
    func subscribe(onValue: @escaping (Output) -> (), onCompleted: (() -> ())? = nil) -> AnyCancellable where Failure == Never {
        return sink(receiveCompletion: { completion in
            onCompleted?()
        }, receiveValue: { value in
            onValue(value)
        })
    }
    
    func data(at keypath: String?) -> Publishers.TryMap<Self, Data> where Output == Data {
        tryMap { (data: Data) -> Data in
            guard let keypath = keypath else { return data }
            
            var json = try JSONSerialization.jsonObject(with: data, options: [])
            for key in keypath.components(separatedBy: "/") {
                guard let dictionatyJSON = json as? [String: Any] else {
                    throw BasicError("Could not cast json to [String: Any] for key '\(key)'")
                }
                if let value = dictionatyJSON[key], !(value is NSNull) {
                    json = value
                } else {
                    throw BasicError("Could not find value for key '\(key)'")
                }
            }
            let resultData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            return resultData
        }
    }
}
