//
//  DomainController.swift
//  App
//
//  Created by Benoit PASQUIER on 27/05/2019.
//

import NIO
import Vapor
import Lighthouse

/// Controls basic CRUD operations on `Domain`s.
struct DomainController: RouteCollection {
    
    
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("domains")
//        todos.get(use: index)
        todos.post(use: parse)

//        todos.group(":id") { todo in
//            todo.get(use: show)
//            todo.put(use: update)
//            todo.delete(use: delete)
//        }
    }
    
    private func handle(_ query: String, eventLoop: EventLoop) -> EventLoopFuture<Domain> {
        let promise = eventLoop.makePromise(of: Domain.self)
        let lighthouse = Lighthouse()
        
        switch lighthouse.makeDomainUrl(for: query) {
        case .failure(let error):
            promise.fail(error)
            return promise.futureResult
        case .success(let urls):
            
            if urls.isEmpty {
                // TODO handle error
                return promise.futureResult
            }
            
            var index = 0
            
            let queue = OperationQueue()
            queue.maxConcurrentOperationCount = 1
            
            var operation: (() -> ()) = { }
            
            operation = {
                lighthouse.getDomainDetails(for: urls[index]) { result in
                    switch result {
                    case .success(let domain):
                        promise.succeed(domain)
                    case .failure(let error):
                        
                        // if invalid host, stop here
                        if (error as? NSError)?.code == -1003 { 
                            promise.fail(error)
                            return
                        }
                        
                        if index < urls.count - 1 {
                            index = index + 1
                            // move on to next url
                            queue.addOperation(operation)
                        } else {
                            promise.fail(error)
                        }
                    }
                }
            }
            
            queue.addOperation(operation)
            return promise.futureResult
        }
    } 
    
    func parse(_ req: Request) throws -> EventLoopFuture<Output> {
        guard let input = try? req.content.decode(Input.self) else {
            throw Abort(.badRequest, reason: "Invalid input")
        }
        
        return handle(input.query, eventLoop: req.eventLoop)
            .map{ domain -> Output in
                return Output(success: true, message: "Some apps can be open from this domain ✌️")
            }
            .flatMapErrorThrowing { error -> Output in 
                return Output(success: false, message: error.outputMessage)
            }
    }
}

struct Input: Content {
    let query: String
}

struct Output: Content {
    let success: Bool
    let message: String
    
    
}

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
