//
//  Domain.swift
//  
//
//  Created by Benoit PASQUIER on 17/09/2020.
//

import Foundation
import Lighthouse

extension Domain {
    var outputMessage: String {
        let appsCount = applinks.details.count
        
        if appsCount == 0 {
            return "The domain is configured but no app listed? 🤔"
        }
        
        var content = ""
        if appsCount == 1 {
            content = "1 app"
        } else {
            content = "\(appsCount) apps"
        }
        
        return "\(content) are associated to this domain ✌️"
    }
    
    func supportedApps(_ urlString: String) -> [String] {
        
        var result: [String] = []
        
        for app in applinks.details {
            
            if let firstPath = app.firstSupportedPath(urlString) {
                if firstPath.hasPrefix("NOT ") {
                    result.append("The link is blocked to open \(app.appId) 🚫")
                } else {
                    result.append("The link can open \(app.appId) ✅")
                }
            }
        }
        
        return result
    }
    
}

extension App {
    
    func firstSupportedPath(_ urlString: String) -> String? {
        guard var searching = URL(string: urlString)?.pathComponents,
            !searching.isEmpty else {
            return nil
        }
        
//        var result: [String] = []

        for path in paths {
            let tmp = path.replacingOccurrences(of: "NOT ", with: "")

            let components = URL(string: tmp)?.pathComponents ?? []
            
            for component in components {                
                if component == "*" && component == components.last {
//                    result.append(path)
//                    break
                    return path
                } else if component == searching.first || component == "*" {
                    searching.removeFirst()
                }
                
                if searching.isEmpty && component != components.last  {
                    break
                }
            }
            
            if searching.isEmpty {
//                result.append(path)
                return path
            }
        }
        
        return nil
    }
}
