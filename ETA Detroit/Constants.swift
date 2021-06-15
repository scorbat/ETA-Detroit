//
//  Constants.swift
//  ETA Detroit
//
//  Created by admin on 6/4/21.
//

import SwiftUI

struct K {
    
    //MARK: - Database Constants
    
    public static let SQLITE_FILE_NAME = "eta_detroit"
    public static let DAY_WEEKDAY = "weekday"
    public static let DAY_SATURDAY = "saturday"
    public static let DAY_SUNDAY = "sunday"
    public static let DAY_EVERYDAY = "everyday"
    
    public static let DIRECTION_SOUTH = "Southbound"
    public static let DIRECTION_NORTH = "Northbound"
    public static let DIRECTION_WEST = "Westbound"
    public static let DIRECTION_EAST = "Eastbound"
    public static let DIRECTION_ONEWAY = "Oneway"
    
    //MARK: - Preview Constants
    
    public static let PREVIEW_COMPANY = Company(id: 2, name: "DDOT", imageURL: "ddot-logo", color: Color(hex: "#054839") ?? Color.purple)
    public static let PREVIEW_ROUTE = Route(id: 1, number: 1, name: "People Mover", description: nil)
    public static let PREVIEW_STOP = Stop(stopID: 246, day: "Test Stop", direction: "westbound")
    
}
