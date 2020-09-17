//
//  Error.swift
//  
//
//  Created by Benoit PASQUIER on 17/09/2020.
//

import Foundation
import Lighthouse

extension Error {
    
    var outputMessage: String {
        if let formatError = self as? UrlFormatError {
            
            switch formatError {
            case .emptyUrl:
                return "The url seems empty 🤷‍♂️"
            case .noValidHost:
                return "The host doesn't seem valid 🤷‍♂️"
            }
        }
        
        if let networkError = self as? NSError {
            
            switch networkError.code {
            case 4864: // "The given data was not valid JSON."
                return "It seems the host doesn't have valid content 🚧"
            case -1003:
                return networkError.localizedDescription + " 🚧"
            default:
                break
            }
        }
        return "I'm not sure what happened 🤔, can you try again?"
    }
}
