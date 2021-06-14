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
            
            Button(action: {
                dataService.toggleDirection()
            }) {
                Image(systemName: "arrow.\(dataService.directionIcon).circle")
                    .resizable(resizingMode: .stretch)
            }
            .frame(width: 40.0, height: 40.0)
            
            if dataService.availableDays() > 1 {
                TabView {
                    if !dataService.weekdayStops.isEmpty {
                        List(dataService.weekdayStops) { stop in
                            StopCellView(dataService: dataService, stop: stop, color: color)
                        }
                        .tabItem {
                            Label("Weekday", systemImage: "1.circle")
                        }
                    }
                    
                    if !dataService.saturdayStops.isEmpty {
                        List(dataService.saturdayStops) { stop in
                            StopCellView(dataService: dataService, stop: stop, color: color)
                        }
                        .tabItem {
                            Label("Saturday", systemImage: "1.circle")
                        }
                    }
                    
                    if !dataService.sundayStops.isEmpty {
                        List(dataService.sundayStops) { stop in
                            StopCellView(dataService: dataService, stop: stop, color: color)
                        }
                        .tabItem {
                            Label("Sunday", systemImage: "1.circle")
                        }
                    }
                }
            } else if dataService.availableDays() == 1 {
                List(dataService.stops) { stop in
                    StopCellView(dataService: dataService, stop: stop, color: color)
                }
            }
        }
        .onAppear {
            dataService.fetchStops(for: route, filter: .none)
        }
    }
}

struct StopsView_Previews: PreviewProvider {
    static var previews: some View {
        StopsView(dataService: DataService(), route: K.PREVIEW_ROUTE, color: Color.purple)
    }
}
