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

extension DomainData { 
    
    var aasaUrl: URL? {

        var urlEntry = url
        if !url.hasPrefix("https://") || url.hasPrefix("http://") {
            urlEntry = "https://" + urlEntry
        }
        
        guard let host = URL(string: urlEntry)?.host else {
            print("No host")
            return nil
        }
        
        var newComponents = URLComponents()
        newComponents.host = host
        newComponents.scheme = "https"
        newComponents.path = "/apple-app-site-association"
        
        return newComponents.url
    }
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
