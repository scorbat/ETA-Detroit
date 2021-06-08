//
//  StopsView.swift
//  ETA Detroit
//
//  Created by admin on 6/8/21.
//

import SwiftUI

struct StopsView: View {
    
    let route: Route
    let color: Color
    
    var stops: [Stop] {
        return DataService.shared.fetchStops(for: route)
    }
    
    var body: some View {
        VStack {
            Text("Stops for \(route.name)")
                .font(.title)
            List {
                ForEach(stops) { stop in
                    StopCellView(stop: stop, color: color)
                }
            }
        }
    }
}

struct StopsView_Previews: PreviewProvider {
    static var previews: some View {
        StopsView(route: K.PREVIEW_ROUTE, color: Color.purple)
    }
}
