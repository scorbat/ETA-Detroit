//
//  StopListView.swift
//  ETA Detroit
//
//  Created by admin on 6/8/21.
//

import SwiftUI

struct StopListView: View {
    
    @ObservedObject var dataService: DataService
    
    let route: Route
    let color: Color
    
    var body: some View {
        List {
            ForEach(dataService.stops) { stop in
                StopCellView(dataService: dataService, stop: stop, color: color)
            }
        }
        .onAppear {
            dataService.fetchStops(for: route)
        }
    }
}

struct StopListView_Previews: PreviewProvider {
    static var previews: some View {
        StopListView(dataService: DataService(), route: K.PREVIEW_ROUTE, color: Color.purple)
    }
}
