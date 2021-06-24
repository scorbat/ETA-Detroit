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
    
    /**
     Takes a given string from the database and converts it into a date object
     */
    static func stringToDate(_ value: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = K.DATABASE_TIME_FORMAT
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return dateFormatter.date(from: value)
    }
    
    /**
     Takes a given date and converts it into a time string in 12 hour format
     */
    static func timeString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = K.DISPLAY_TIME_FORMAT
        
        return dateFormatter.string(from: date)
    }
    
    /**
     Returns how many minutes until the specified date
     */
    static func minutes(to date: Date) -> Int {
        return Int(date.compareTimeToNow() / 60)
    }
    
}
