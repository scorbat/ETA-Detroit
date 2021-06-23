//
//  StopsMapView.swift
//  ETA Detroit
//
//  Created by admin on 6/21/21.
//

import SwiftUI
import MapKit

struct StopsMapView: View {
    
    @StateObject var mapService = MapService()
    
    @State var stops: [Stop]
    var pinColor: Color
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: K.DETROIT_LATITUDE, longitude: K.DETROIT_LONGITUDE),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    @State var selected: Stop? = nil //nothing selected by default
    
    var body: some View {
        //when the stops are loaded, display the map with annotations
        if stops.count > 0 {
            Map(coordinateRegion: $mapService.region, annotationItems: stops) { stop in
                MapAnnotation(coordinate: stop.coordinate) {
                    VStack {
                        //if this is the selected stop, then display the name above
                        if selected == stop {
                            Text(stop.name)
                        }
                        
                        Image(systemName: "mappin")
                            .onTapGesture {
                                selected = stop
                            }
                    }
                }
            }
            .onAppear {
                mapService.generateRegion(for: stops.first!)
            }
        } else {
            //show that we're loading the map
            ProgressView()
        }
    }
}

struct StopsMapView_Previews: PreviewProvider {
    static var previews: some View {
        StopsMapView(stops: [K.PREVIEW_STOP], pinColor: .red)
    }
}
