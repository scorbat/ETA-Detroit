//
//  StopsMapView.swift
//  ETA Detroit
//
//  Created by admin on 6/21/21.
//

import SwiftUI
import MapKit

struct StopsMapView: View {
    
    @State var stops: [Stop]
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: K.DETROIT_LATITUDE, longitude: K.DETROIT_LONGITUDE),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: stops) { stop in
            MapPin(coordinate: stop.coordinate, tint: .green)
        }
    }
}

struct StopsMapView_Previews: PreviewProvider {
    static var previews: some View {
        StopsMapView(stops: [K.PREVIEW_STOP])
    }
}
