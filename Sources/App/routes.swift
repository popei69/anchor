import Vapor

struct Context: Codable {
    var output: Output?
    var query: String?
}

/// Register your application's routes here.
func routes(_ app: Application) throws {

    app.get { req in
        return req.view.render("index")
    }
    
    app.post { req -> EventLoopFuture<View> in
        req.client.post("http://127.0.0.1:8080/domains", headers: req.headers) { clientRequest in
            let input = try req.content.decode(Input.self)
            try clientRequest.content.encode(input)
        }
        .flatMapThrowing { try $0.content.decode(Output.self) }
        .flatMap{ output -> EventLoopFuture<View> in
            let input = try? req.content.decode(Input.self)
            return req.view.render("index", Context(output: output, query: input?.query))
        }
    }
    
    try app.register(collection: DomainController())
}
