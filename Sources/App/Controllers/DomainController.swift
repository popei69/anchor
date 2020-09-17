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
        todos.post(use: parse)
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
                let bundles = domain.applinks.details.map { $0.appId }
                let output = Output(success: true, message: domain.outputMessage, bundles: bundles)
//                output.supportedBundles = domain.supportedApps(input.query)
                return output
            }
            .flatMapErrorThrowing { error -> Output in 
                return Output(success: false, message: error.outputMessage)
            }
    }
    
    func render(_ req: Request) -> EventLoopFuture<View> {
        do {
            return try parse(req)
                .flatMap { req.view.render("index", $0) }
        } catch {
            let output = Output(success: false, message: error.outputMessage)
            return req.view.render("index", output)
        }   
    }
}
