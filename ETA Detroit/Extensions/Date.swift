//
//  Date.swift
//  ETA Detroit
//
//  Created by admin on 6/16/21.
//

import Foundation

/**
 Modeled from https://stackoverflow.com/questions/41646542/how-do-you-compare-just-the-time-of-a-date-in-swift
 Times pulled from the database are stored with a default date of 01-01-2000.  This makes comparing it to the current date tricky, since
 we only care about the difference in times.  This extension provides a method to compare only the times between two dates.
 */
extension Date {
    
    func secondsFromBeginningOfDay() -> TimeInterval {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute, .second], from: self)
        
        let seconds = dateComponents.hour! * 3600 + dateComponents.minute! * 60 + dateComponents.second!
        return TimeInterval(seconds)
    }
    
    func compareTimeOfDate(to date: Date) -> TimeInterval {
        let time1 = secondsFromBeginningOfDay()
        let time2 = date.secondsFromBeginningOfDay()
        
        return time1 - time2
    }
    
    func compareTimeToNow() -> TimeInterval {
        return compareTimeOfDate(to: Date())
    }
    
}
