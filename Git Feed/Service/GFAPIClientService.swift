//
//  GFAPIClientService.swift
//  Git Feed
//
//  Created by Anton Chuev on 11/12/18.
//  Copyright © 2018 Anton Chuiev. All rights reserved.
//

import PromiseKit

class GFAPIClientService {
    var task: URLSessionTask?
    
    func sendGETRequest(at path: String,
                        withQuery query: [String: Any]? = nil,
                        withHeaders headers: [String: String]?) -> Promise<Data> {
        
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = "GET"
        return urlTaskWith(request: request as URLRequest)
    }
    
    func sendPOSTRequest(at path: String,
                         withQuery query: [String: Any]? = nil,
                         withHeaders headers: [String: String]?) -> Promise<Data> {
        
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = "POST"
        return urlTaskWith(request: request as URLRequest)
    }
    
    
    func sendPUTRequest(at path: String,
                        withQuery query: [String: Any]? = nil,
                        withHeaders headers: [String: String]?) -> Promise<Data> {
        
        var request = URLRequest(url: URL(string : path)!)
        request.httpMethod = "PUT"
        return urlTaskWith(request: request as URLRequest)
    }
    
    func sendDELETERequest(at path: String,
                           withQuery query: [String: Any]? = nil,
                           withHeaders headers: [String: String]?) -> Promise<Data> {
        
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = "DELETE"
        return urlTaskWith(request: request as URLRequest)
    }
    
    // MARK: - Private
    fileprivate func urlTaskWith(request: URLRequest) -> Promise<Data> {
        return Promise<Data> { resolver in
            let task = GFNetworkManager.shared.session.dataTask(with: request) { (data, response, error) in
                
                defer {
                    self.task = nil
                }
                
                if let error = error {
                    print(error)
                }
                resolver.resolve(data, error)
            }
            self.task = task
            task.resume()
        }
    }
}


