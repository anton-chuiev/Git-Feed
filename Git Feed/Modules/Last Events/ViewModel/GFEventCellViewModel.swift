//
//  GFEventCellViewModel.swift
//  Git Feed
//
//  Created by Anton Chuev on 11/12/18.
//  Copyright © 2018 Anton Chuiev. All rights reserved.
//

import Foundation

final class GFEventCellViewModel: GFBaseCellViewModel {
    var event: GFEvent
    
    init(event: GFEvent) {
        self.event = event
    }
    
    var eventTitle: String {
        return event.username
    }
    
    var eventDescription: String {
        return event.repoName + ", " + event.action.replacingOccurrences(of: "Event", with: "").lowercased()
    }
    
    var eventImageURL: URL? {
        return event.userImageUrl
    }
}
