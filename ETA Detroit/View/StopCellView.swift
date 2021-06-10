//
//  StopCellView.swift
//  ETA Detroit
//
//  Created by admin on 6/8/21.
//

import SwiftUI

struct StopCellView: View {
    
    @ObservedObject var dataService: DataService
    
    let stop: Stop
    let color: Color
    
    var stopInfo: (name: String, latitude: Double, longitude: Double) {
        return dataService.getStopInfo(for: stop)!
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(stopInfo.name)
                .font(.headline)
                .foregroundColor(color)
            Text("\(stopInfo.latitude), \(stopInfo.longitude)")
            Text(stop.direction)
            Text(stop.day)
        }
    }
}

struct StopCellView_Previews: PreviewProvider {
    static var previews: some View {
        StopCellView(dataService: DataService(), stop: K.PREVIEW_STOP, color: Color.purple)
    }
}
