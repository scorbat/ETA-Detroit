//
//  Stop.swift
//  ETA Detroit
//
//  Created by admin on 6/7/21.
//

import Foundation

struct Stop: Identifiable {
    
    let stopID: Int
    let day: String
    let direction: String
    
    //compute unique id (can't use stop_id since there are multiple of same id)
    var id: String {
        return "\(stopID),\(day),\(direction)"
    }
    
}
