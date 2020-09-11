//
//  DomainController.swift
//  App
//
//  Created by Benoit PASQUIER on 27/05/2019.
//

import Vapor
import Lighthouse

/// Controls basic CRUD operations on `Domain`s.
final class DomainController {
    
    let lighthouse = Lighthouse()
    
    func parse(_ req: Request, data: DomainData) throws -> String {
        
//        if let url = data.aasaUrl {
//            
//            getAppDomain(for: url, completion: { domain in
//                print("found \(domain?.applinks.details.count ?? 0) apps")
//            })
//        }

        return "Hello \(data.url)"
    }
    
}

//class RequestHandler {
//    
//    func handle(_ input: Input, callback: @escaping (Result<Domain, Error>) -> Void) {
//        let lighthouse = Lighthouse()
//        
//        
//        switch lighthouse.makeDomainUrl(for: input.query) {
//        case .failure(let error):
//            callback(.failure(error))
//        case .success(let urls):
//            
//            if urls.isEmpty {
//                return
//            }
//            
//            var index = 0
//            
//            let queue = OperationQueue()
//            queue.maxConcurrentOperationCount = 1
//            
//            var operation: (() -> ())?
//            
//            operation = {
//                lighthouse.getDomainDetails(for: urls[index]) { result in
//                    switch result {
//                    case .success(let domain):
//                        callback(.success(domain))
//                    case .failure(let error):
//                        
//                        // if invalid host, stop here
//                        if (error as? NSError)?.code == -1003 { 
//                            callback(.failure(error))
//                            return
//                        }
//                        
//                        if index < urls.count - 1 {
//                            index = index + 1
//                            // move on to next url
//                            queue.addOperation(operation!)
//                        } else {
//                            callback(.failure(error))
//                        }
//                    }
//                }
//            }
//            
//            queue.addOperation(operation!)
//        }
//    }
//}
//
//extension Error {
//    
//    var outputMessage: String {
//        if let formatError = self as? UrlFormatError {
//            
//            switch formatError {
//            case .emptyUrl:
//                return "The url seems empty 🤷‍♂️"
//            case .noValidHost:
//                return "The host doesn't seem valid 🤷‍♂️"
//            }
//        }
//        
//        if let networkError = self as? NSError {
//            
//            switch networkError.code {
//            case 4864: // "The given data was not valid JSON."
//                return "It seems the host doesn't have valid content 🚧"
//            case -1003:
//                return networkError.localizedDescription + " 🚧"
//            default:
//                break
//            }
//        }
//        return "I'm not sure what happened 🤔, can you try again?"
//    }
//}
