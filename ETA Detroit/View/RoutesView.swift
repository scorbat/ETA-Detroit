//
//  RoutesView.swift
//  ETA Detroit
//
//  Created by admin on 6/7/21.
//

import SwiftUI

struct RoutesView: View {
    
    let company: Company
    
    var routes: [Route] {
        return DataService.shared.fetchRoutes(for: company)
    }
    
    var body: some View {
        VStack {
            Text("\(company.name) Routes")
                .font(.title)
            List {
                ForEach(routes) { route in
                    NavigationLink(
                        destination: StopsView(route: route, color: company.color),
                        label: {
                            RouteCellView(route: route, color: company.color)
                        })
                }
            }
        }
    }
}

struct RoutesView_Previews: PreviewProvider {
    static var previews: some View {
        RoutesView(company: K.PREVIEW_COMPANY)
    }
}
