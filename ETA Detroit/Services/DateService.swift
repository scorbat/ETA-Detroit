//
//  DateService.swift
//  ETA Detroit
//
//  Created by admin on 6/17/21.
//

import Foundation

/**
 Provides some utility functions for manipulating strings and dates
 */
struct DateService {
    
    static func stringToDate(_ value: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = K.TIME_FORMAT
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return dateFormatter.date(from: value)
    }
    
    static func timeString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        
        return dateFormatter.string(from: date)
    }
    
}
