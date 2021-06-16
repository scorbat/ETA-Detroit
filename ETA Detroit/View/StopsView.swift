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
            
            if dataService.directions.count > 1 {
                Button(action: {
                    dataService.toggleDirection()
                    dataService.fetchStops(for: route)
                }) {
                    Image(systemName: "arrow.\(dataService.getDirectionIcon()).circle")
                        .resizable(resizingMode: .stretch)
                }
                .frame(width: 40.0, height: 40.0)
            }
            
            List(dataService.stops) { stop in
                StopCellView(dataService: dataService, stop: stop, color: color)
            }
            
            //Day selection
            
            if dataService.days.count > 1 {
                HStack {
                    ForEach(dataService.days, id: \.self) { day in
                        Button(action: {
                            dataService.selectedDay = day
                            dataService.fetchStops(for: route)
                        }) {
                            Text(day.capitalized)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(maxWidth: .infinity)
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
