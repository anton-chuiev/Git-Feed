//
//  GFLastEventsService.swift
//  Git Feed
//
//  Created by Anton Chuev on 11/12/18.
//  Copyright © 2018 Anton Chuiev. All rights reserved.
//

import PromiseKit

enum GFLastEventsError : Error {
    case formatError
}

final class GFLastEventsService: GFAPIClientService {
    private var urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    func execute() -> Promise<[GFEvent]> {
        return Promise<[GFEvent]> { resolver in
            firstly {
                return sendGETRequest(at: urlString, withHeaders: nil)
            }.done { data in
                do {
                    let decoder = JSONDecoder()
                    let events = try decoder.decode([GFEvent].self, from: data)
                    resolver.fulfill(events)
                } catch {
                    resolver.reject(GFLastEventsError.formatError)
                }
            }.catch { error in
                resolver.reject(error)
            }
        }
    }
}
