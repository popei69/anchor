//
//  DomainController.swift
//  App
//
//  Created by Benoit PASQUIER on 27/05/2019.
//

import Vapor

/// Controls basic CRUD operations on `Domain`s.
final class DomainController {
    
    func parse(_ req: Request, data: DomainData) throws -> String {
        
        if let url = data.aasaUrl {
            
            getAppDomain(for: url, completion: { domain in
                print("found \(domain?.applinks.details.count ?? 0) apps")
            })
        }

        return "Hello \(data.url)"
    }
    
    private func getAppDomain(for url: URL, completion: ((Domain?) -> (Void))?) {
        
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
}
