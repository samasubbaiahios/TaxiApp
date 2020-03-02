//
//  Modelable.swift
//  FreeNowTest
//
//  Created by Venkata Subbaiah Sama on 31/07/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import Foundation

protocol Modelable {
    // simple marker protocol,
    // it marks Type conformable to this protocol
}

extension Modelable {
    static func createCodableModel<T: Codable>(from json: JSON, of type: T.Type) -> T? {
        var model: T?
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
            model = try JSONDecoder().decode(type, from: jsonData)
        } catch {
            print("Could not decode object of type: \(T.self), due to an error=\(error)")
        }
        
        return model
    }
}
