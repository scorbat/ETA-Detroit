//
//  MapService.swift
//  ETA Detroit
//
//  Created by admin on 6/22/21.
//

import Foundation
import MapKit

class MapService: ObservableObject {
    
    @Published var region = MKCoordinateRegion()
    
    func generateRegion(for stop: Stop) {
        self.region = MKCoordinateRegion(
            center: stop.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    }
    
}
