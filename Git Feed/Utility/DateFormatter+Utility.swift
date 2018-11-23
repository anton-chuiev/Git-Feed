//
//  DateFormatter+Utility.swift
//  Git Feed
//
//  Created by Anton Chuev on 11/20/18.
//  Copyright © 2018 Anton Chuiev. All rights reserved.
//

import Foundation

enum GFDateFormatError : Error {
    case wrongFormat
}

extension DateFormatter {
    static let githubApiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
