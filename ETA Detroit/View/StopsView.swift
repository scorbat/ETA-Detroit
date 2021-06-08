//
//  StopsView.swift
//  ETA Detroit
//
//  Created by admin on 6/8/21.
//

import SwiftUI

struct StopsView: View {
    
    let route: Route
    
    var stops: [Stop] {
        return DataService.shared.fetchStops(for: route)
    }
    
    var body: some View {
        List {
            ForEach(stops) { stop in
                StopCellView(stop: stop)
            }
        }
    }
}

struct StopsView_Previews: PreviewProvider {
    static var previews: some View {
        StopsView(route: K.PREVIEW_ROUTE)
    }
}
