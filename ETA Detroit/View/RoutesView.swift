//
//  RoutesView.swift
//  ETA Detroit
//
//  Created by admin on 6/7/21.
//

import SwiftUI

struct RoutesView: View {
    
    @ObservedObject var dataService: DataService
    
    let company: Company
    
    var body: some View {
        VStack {
            Text("\(company.name) Routes")
                .font(.title)
            List {
                ForEach(dataService.routes) { route in
                    NavigationLink(
                        destination: StopsView(dataService: dataService, route: route, color: company.color),
                        label: {
                            RouteCellView(route: route, color: company.color)
                        })
                }
            }
        }
        .onAppear {
            dataService.fetchRoutes(for: company)
        }
    }
}

struct RoutesView_Previews: PreviewProvider {
    static var previews: some View {
        RoutesView(dataService: DataService(), company: K.PREVIEW_COMPANY)
    }
}
