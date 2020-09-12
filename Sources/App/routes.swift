import Vapor

/// Register your application's routes here.
func routes(_ app: Application) throws {

    app.get { req in
//        req.view.render("index", [
//            "title": "Hi",
//            "body": "Hello world!"
//        ])
        req.view.render("welcome")
    }
    
    
    // Says hello
    app.get("hello", ":name") { req -> String in
        let name = req.parameters.get("name")!
        return "Hello, \(name)!"
    }
    
    try app.register(collection: DomainController())
}
