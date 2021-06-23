//
//  MapPinTapView.swift
//  ETA Detroit
//
//  Created by admin on 6/23/21.
//

import SwiftUI

struct MapPinTapView: View {
    
    let text: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
            Text(text)
                .foregroundColor(.white)
                .padding()
        }
        .fixedSize() //this allows the view to expand as needed
    }
}

struct MapPinTapView_Previews: PreviewProvider {
    static var previews: some View {
        MapPinTapView(text: "Stop String")
    }
}
