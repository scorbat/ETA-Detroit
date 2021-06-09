//
//  StopsView.swift
//  ETA Detroit
//
//  Created by admin on 6/8/21.
//

import SwiftUI

struct StopsView: View {
    
    @ObservedObject var dataService: DataService
    
    let route: Route
    let color: Color
    
    var body: some View {
        VStack {
            Text("Stops for \(route.name)")
                .font(.title)

            TabView {
                StopListView(dataService: dataService, route: route, color: color).tabItem {
                    Label("Weekday", systemImage: "1.circle")
                }
                
                Text("Saturday").tabItem {
                    Label("Saturday", systemImage: "2.circle")
                }
                
                Text("Sunday").tabItem {
                    Label("Sunday", systemImage: "3.circle")
                }
            }
        }
    }
}

struct StopsView_Previews: PreviewProvider {
    static var previews: some View {
        StopsView(dataService: DataService(), route: K.PREVIEW_ROUTE, color: Color.purple)
    }
}
