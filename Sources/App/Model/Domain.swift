//
//  Domain.swift
//  App
//
//  Created by Benoit PASQUIER on 27/05/2019.
//

import Vapor

// inputs 
struct DomainData: Content {
    let url: String
}

// outputs
struct Domain: Codable {
    let applinks: AppDomain 
}

struct AppDomain: Codable {
    let details: [App]
}

struct App: Codable {
    let appId: String
    let paths: [String]
    
    private enum CodingKeys: String, CodingKey {
        case appId = "appID"
        case paths = "paths"
    }
}
