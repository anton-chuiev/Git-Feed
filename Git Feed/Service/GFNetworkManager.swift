//
//  GFNetworkManager.swift
//  Git Feed
//
//  Created by Anton Chuev on 11/12/18.
//  Copyright © 2018 Anton Chuiev. All rights reserved.
//

import UIKit

final class GFNetworkManager: NSObject {
    static let shared = GFNetworkManager()
    
    lazy var session : URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session
    }()
}
