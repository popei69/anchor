import Vapor

public func getAppDomain(for url: URL, completion: ((Domain?) -> (Void))?) {
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            completion?(nil)
            return
        }
        
        let decoder = JSONDecoder()
        let domain = try? decoder.decode(Domain.self, from: data)
        
        completion?(domain)
        }.resume()
}


/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // "It works" page
    router.get { req in
        return try req.view().render("welcome")
    }
    
    // Says hello
    router.get("hello", String.parameter) { req -> Future<View> in
        return try req.view().render("hello", [
            "name": req.parameters.next(String.self)
        ])
    }
    
    router.post(DomainData.self, at: "domain") { req, data -> String in
        
        if let url = data.aasaUrl {
            
            getAppDomain(for: url, completion: { domain in
                print("found \(domain?.applinks.details.count ?? 0) apps")
            })
            
        }
        
        return "Hello \(urlString)"
    }
    
}
