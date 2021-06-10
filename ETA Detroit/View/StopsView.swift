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
//                StopListView(dataService: dataService, stopFilter: .weekday, route: route, color: color).tabItem {
//                    Label("Weekday", systemImage: "1.circle")
//                }
//
//                StopListView(dataService: dataService, stopFilter: .saturday, route: route, color: color).tabItem {
//                    Label("Saturday", systemImage: "2.circle")
//                }
//
//                StopListView(dataService: dataService, stopFilter: .sunday, route: route, color: color).tabItem {
//                    Label("Sunday", systemImage: "3.circle")
//                }
                ForEach(dataService.getDaysOfCurrentStops(), id: \.self) { day in
                    Text(day)
                        .tabItem {
                            Label(day, systemImage: "1.circle")
                        }
                }
            }
        }
        .onAppear {
            dataService.fetchStops(for: route)
        }
    }
}

struct StopsView_Previews: PreviewProvider {
    static var previews: some View {
        StopsView(dataService: DataService(), route: K.PREVIEW_ROUTE, color: Color.purple)
    }
}
