//
//  GFEvent.swift
//  Git Feed
//
//  Created by Anton Chuev on 11/12/18.
//  Copyright © 2018 Anton Chuiev. All rights reserved.
//

import Foundation

class GFEvent: Codable {
    var id: String
    var createdAt: Date
    var repoName: String
    var username: String
    var userImageUrl: URL?
    var action: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case action = "type"
        case repo = "repo"
        case actor = "actor"
    }
    
    private enum ActorCodingKeys: String, CodingKey {
        case username = "display_login"
        case userImageUrl = "avatar_url"
    }
    
    private enum RepoCodingKeys: String, CodingKey {
        case repoName = "name"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        guard let date = DateFormatter.githubApiDateFormatter.date(from: createdAtString) else {
            throw GFDateFormatError.wrongFormat
        }
        createdAt = date

        action = try container.decode(String.self, forKey: .action)
        
        // Nested containers
        let repoContainer = try container.nestedContainer(keyedBy: RepoCodingKeys.self, forKey: .repo)
        repoName = try repoContainer.decode(String.self, forKey: .repoName)
        
        let actorContainer = try container.nestedContainer(keyedBy: ActorCodingKeys.self, forKey: .actor)
        username = try actorContainer.decode(String.self, forKey: .username)
        if let imageUrlString = try? actorContainer.decode(String.self, forKey: .userImageUrl) {
            userImageUrl = URL(string: imageUrlString)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        let createdAtString = DateFormatter.githubApiDateFormatter.string(from: createdAt)
        try container.encode(createdAtString, forKey: .createdAt)
    
        try container.encode(action, forKey: .action)
        
        // Nested containers
        var repoContainer = container.nestedContainer(keyedBy: RepoCodingKeys.self, forKey: .repo)
        try repoContainer.encode(repoName, forKey: .repoName)
        
        var actorContainer = container.nestedContainer(keyedBy: ActorCodingKeys.self, forKey: .actor)
        try actorContainer.encode(username, forKey: .username)
        try actorContainer.encode(userImageUrl?.absoluteString, forKey: .userImageUrl)
    }
}

extension GFEvent: Hashable {
    var hashValue: Int {
        return id.hashValue
    }
    
    static func == (lhs: GFEvent, rhs: GFEvent) -> Bool {
        return lhs.id == rhs.id
    }
}
