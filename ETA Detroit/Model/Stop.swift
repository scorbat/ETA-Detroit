//
//  Stop.swift
//  ETA Detroit
//
//  Created by admin on 6/7/21.
//

import Foundation
import MapKit

struct Stop: Identifiable, Equatable {
    
    let stopID: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let day: String
    let direction: String
    let route: Route //reference to route that this stop object is on
    
    //compute unique id (can't use stop_id since there are multiple of same id)
    var id: String {
        return "\(stopID),\(day),\(direction)"
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func == (lhs: Stop, rhs: Stop) -> Bool {
        return lhs.stopID == rhs.stopID
    }
    
}
