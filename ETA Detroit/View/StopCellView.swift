//
//  StopCellView.swift
//  ETA Detroit
//
//  Created by admin on 6/8/21.
//

import SwiftUI

struct StopCellView: View {
    
    @ObservedObject var dataService: DataService
    
    @State var times = [Date]()
    
    let stop: Stop
    let color: Color
    
    var stopInfo: (name: String, latitude: Double, longitude: Double) {
        return dataService.getStopInfo(for: stop)!
    }
    
    var body: some View {
        Button(action: {
            times = dataService.fetchStopTimes(for: stop)
        }) {
            VStack(alignment: .leading) {
                Text(stopInfo.name)
                    .font(.headline)
                    .foregroundColor(color)
                if times.count > 0 {
                    Text("Next stop: x minutes (\(DateService.timeString(from: times.first!)))")
                } else {
                    Text("")
                }
                Label("MORE STOP TIMES", systemImage: "clock")
            }
        }
        .onAppear {
            times = dataService.fetchStopTimes(for: stop)
        }
    }
}

struct StopCellView_Previews: PreviewProvider {
    static var previews: some View {
        StopCellView(dataService: DataService(), stop: K.PREVIEW_STOP, color: Color.purple)
    }
}
