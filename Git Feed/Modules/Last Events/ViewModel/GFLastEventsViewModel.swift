//
//  GFLastEventsViewModel.swift
//  Git Feed
//
//  Created by Anton Chuev on 11/12/18.
//  Copyright © 2018 Anton Chuiev. All rights reserved.
//

import RxSwift
import PromiseKit
import Foundation

final class GFLastEventsViewModel {
    var models = Variable([GFEventCellViewModel]())
    private var events = [GFEvent]()
    
    private let cachedEventsKey = "Events"
    private let maxEventsCount = 30
    private var isLoading = false
    
    func loadSavedEvents() {
        if let data = UserDefaults.standard.object(forKey: cachedEventsKey) as? Data {
            do {
                events = try JSONDecoder().decode([GFEvent].self, from: data)
                models.value = events.compactMap(GFEventCellViewModel.init)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetch() {
        if isLoading == true { return }
        
        isLoading = true
        firstly {
            return GFLastEventsService(urlString: GFURLBuilder.lastEventsURLString()).execute()
            }.done(on: DispatchQueue.global(), { [weak self] events in
                self?.processEvents(events, completion: { error in
                    self?.isLoading = false
                })
            }).catch { [weak self] error in
                print(error.localizedDescription)
                self?.isLoading = false
            }.finally {
                print("Events have been fetched")
        }
    }
    
    fileprivate func processEvents(_ newEvents: [GFEvent], completion: (Error?) -> Void) {
        let existingEvents = Set(events)
        let incomingEvents = Set(newEvents)
        
        let uniqueEvents = incomingEvents.subtracting(existingEvents)
        
        let currentEvents = uniqueEvents + events
        var sortedEvents = currentEvents.sorted { (firstEvent, secondEvent) -> Bool in
            return firstEvent.createdAt > secondEvent.createdAt
        }
        
        if sortedEvents.count > maxEventsCount {
            sortedEvents = Array(sortedEvents.prefix(upTo: maxEventsCount))
        }
        
        models.value = sortedEvents.map { event in
            return GFEventCellViewModel(event: event)
        }
        
        saveEvents(currentEvents, completion: completion)
    }
    
    fileprivate func saveEvents(_ events: [GFEvent], completion: (Error?) -> Void) {
        do {
            let encodedData = try JSONEncoder().encode(events)
            UserDefaults.standard.set(encodedData, forKey: cachedEventsKey)
            UserDefaults.standard.synchronize()
            completion(nil)
        } catch {
            print(error.localizedDescription)
            completion(error)
        }
    }
}

