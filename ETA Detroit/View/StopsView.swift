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
                dataService.fetchStops(for: route)
            }) {
                Image(systemName: "arrow.\(dataService.getDirectionIcon()).circle")
                    .resizable(resizingMode: .stretch)
            }
            .frame(width: 40.0, height: 40.0)
            
            if dataService.days.count > 1 {
                TabView {
                    ForEach(dataService.days, id: \.self) { day in
                        List(dataService.stops) { stop in
                            StopCellView(dataService: dataService, stop: stop, color: color)
                        }
                        .tabItem {
                            Text(day.capitalized)
                        }
                        .onAppear {
                            //print("Selected day: \(day)")
                            dataService.selectedDay = day
                            dataService.fetchStops(for: route)
                        }
                    }
                }
            } else if dataService.days.count == 1 {
                List(dataService.stops) { stop in
                    StopCellView(dataService: dataService, stop: stop, color: color)
                }
            }
            
        }
        .onAppear {
            dataService.fetchRouteData(for: route)
            dataService.fetchStops(for: route)
        }
        .onDisappear {
            dataService.selectedDay = nil
            dataService.selectedDirection = nil
        }
    }
}

struct StopsView_Previews: PreviewProvider {
    static var previews: some View {
        StopsView(dataService: DataService(), route: K.PREVIEW_ROUTE, color: Color.purple)
    }
}
