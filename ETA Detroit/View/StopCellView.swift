//
//  StopCellView.swift
//  ETA Detroit
//
//  Created by admin on 6/8/21.
//

import SwiftUI

struct StopCellView: View {
    
    let stop: Stop
    
    var body: some View {
        VStack {
            Text(stop.name)
            Text("\(stop.latitude)")
            Text("\(stop.longitude)")
        }
    }
}

struct StopCellView_Previews: PreviewProvider {
    static var previews: some View {
        StopCellView(stop: K.PREVIEW_STOP)
    }
}
