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
    
    var existingDays: [String] {
        return dataService.getDaysOfCurrentStops()
    }
    
    var body: some View {
        VStack {
            Text("Stops for \(route.name)")
                .font(.title)

            //if there are multiple options then display those
            if existingDays.count > 1 {
                TabView {
                    ForEach(existingDays, id: \.self) { day in
                        List(dataService.stops[day]!) { stop in
                            StopCellView(dataService: dataService, stop: stop, color: color)
                        }
                        .tabItem {
                            Label(day, systemImage: "1.circle")
                        }
                    }
                }
            //otherwise don't display the option
            } else if existingDays.count == 1 {
                List(dataService.stops[existingDays[0]]!) { stop in
                    StopCellView(dataService: dataService, stop: stop, color: color)
                }
                .tabItem {
                    Label(existingDays[0], systemImage: "1.circle")
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
