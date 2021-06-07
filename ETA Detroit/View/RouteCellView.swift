//
//  RouteCellView.swift
//  ETA Detroit
//
//  Created by admin on 6/7/21.
//

import SwiftUI

struct RouteCellView: View {
    
    let route: Route
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("ROUTE \(route.number)")
                .font(.headline)
                .foregroundColor(Color.purple)
            Text(route.name.capitalized)
                .font(.title2)
        }
    }
}

struct RouteCellView_Previews: PreviewProvider {
    static var previews: some View {
        RouteCellView(route: K.PREVIEW_ROUTE)
    }
}
