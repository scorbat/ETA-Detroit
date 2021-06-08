//
//  StopCellView.swift
//  ETA Detroit
//
//  Created by admin on 6/8/21.
//

import SwiftUI

struct StopCellView: View {
    
    let stop: Stop
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(stop.name)
                .font(.headline)
                .foregroundColor(color)
            Text("\(stop.latitude)")
            Text("\(stop.longitude)")
        }
    }
}

struct StopCellView_Previews: PreviewProvider {
    static var previews: some View {
        StopCellView(stop: K.PREVIEW_STOP, color: Color.purple)
    }
}
