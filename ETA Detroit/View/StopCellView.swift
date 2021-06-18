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
    @State var expanded = false
    
    let stop: Stop
    let color: Color
    
    var stopInfo: (name: String, latitude: Double, longitude: Double) {
        return dataService.getStopInfo(for: stop)!
    }
    
    var body: some View {
        VStack {
            Button(action: {
                //times = dataService.fetchStopTimes(for: stop)
                expanded.toggle()
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
            
            if expanded {
                ForEach(1..<4) { index in
                    if let time = times[index] {
                        Text("Bus at \(DateService.timeString(from: time))")
                    }
                }
            }
        }
    }
}

struct StopCellView_Previews: PreviewProvider {
    static var previews: some View {
        StopCellView(dataService: DataService(), stop: K.PREVIEW_STOP, color: Color.purple)
    }
}
