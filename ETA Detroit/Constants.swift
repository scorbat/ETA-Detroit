//
//  Constants.swift
//  ETA Detroit
//
//  Created by admin on 6/4/21.
//

import SwiftUI

struct K {
    
    public static let SQLITE_FILE_NAME = "eta_detroit"
    
    public static let PREVIEW_COMPANY = Company(id: 2, name: "DDOT", imageURL: "ddot-logo", color: Color(hex: "#054839") ?? Color.purple)
    public static let PREVIEW_ROUTE = Route(id: 1, number: 1, name: "People Mover", description: nil)
    public static let PREVIEW_STOP = Stop(stopID: 246, dayID: 1, directionID: 4)
    
}
