//
//  Output.swift
//  
//
//  Created by Benoit PASQUIER on 17/09/2020.
//

import Vapor

struct Output: Content {
    let success: Bool
    let message: String
    let bundles: [String]?
    
    var supportedBundles: [String]?
}

extension Output {
    init(success: Bool, message: String) {
        self.init(success: success, message: message, bundles: nil)
    }
}
