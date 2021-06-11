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

//            TabView {
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
//            }
            if dataService.availableDays() > 1 {
                TabView {
                    if !dataService.weekdayStops.isEmpty {
                        Text("Weekday")
                            .tabItem {
                                Label("Weekday", systemImage: "1.circle")
                            }
                    }
                    
                    if !dataService.saturdayStops.isEmpty {
                        Text("Saturday")
                            .tabItem {
                                Label("Saturday", systemImage: "1.circle")
                            }
                    }
                    
                    if !dataService.sundayStops.isEmpty {
                        Text("Sunday")
                            .tabItem {
                                Label("Sunday", systemImage: "1.circle")
                            }
                    }
                }
            } else if dataService.availableDays() == 1 {
                
            }
        }
        .onAppear {
            dataService.fetchStops(for: route, filter: .none)
            print(dataService.stops.count)
            print(dataService.weekdayStops.count)
        }
    }
}

struct StopsView_Previews: PreviewProvider {
    static var previews: some View {
        StopsView(dataService: DataService(), route: K.PREVIEW_ROUTE, color: Color.purple)
    }
}
