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
    
    init(dataService: DataService, route: Route, color: Color) {
        self.dataService = dataService
        self.route = route
        self.color = color
        
        UINavigationBar.appearance().backgroundColor = UIColor(color)
    }
    
    var body: some View {
        VStack(spacing: 20) {
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
            
            //Day selection
            
            if dataService.days.count > 1 {
                HStack {
                    ForEach(dataService.days, id: \.self) { day in
                        Button(action: {
                            dataService.selectedDay = day
                            dataService.fetchStops(for: route)
                        }) {
                            ZStack {
                                if isSelected(day) {
                                    Color.blue
                                }
                                Text(day.capitalized)
                                    .foregroundColor(isSelected(day) ? .white : nil)
                            }
                                
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 40.0)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            
            //display stops
            List(dataService.stops) { stop in
                StopCellView(dataService: dataService, stop: stop, color: color)
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
        .navigationBarTitle(Text("Stops for \(route.name)"), displayMode: .inline)
        .padding(.top)
        
    }
    
    private func isSelected(_ day: String) -> Bool {
        return day == dataService.selectedDay
    }
}

struct StopsView_Previews: PreviewProvider {
    static var previews: some View {
        StopsView(dataService: DataService(), route: K.PREVIEW_ROUTE, color: Color.purple)
    }
}
