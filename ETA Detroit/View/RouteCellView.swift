//
//  RouteCellView.swift
//  ETA Detroit
//
//  Created by admin on 6/7/21.
//

import SwiftUI

struct RouteCellView: View {
    
    let route: Route
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("ROUTE \(route.number)")
                .font(.headline)
                .foregroundColor(color)
            Text(route.name.capitalized)
                .font(.title2)
        }
    }
}

struct RouteCellView_Previews: PreviewProvider {
    static var previews: some View {
        RouteCellView(route: K.PREVIEW_ROUTE, color: Color.purple)
    }
}
