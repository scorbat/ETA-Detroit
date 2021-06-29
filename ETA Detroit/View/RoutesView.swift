//
//  RoutesView.swift
//  ETA Detroit
//
//  Created by admin on 6/7/21.
//

import SwiftUI

struct RoutesView: View {
    
    @ObservedObject var dataService: DataService
    
    @State private var searchText = "" //default empty
    
    let company: Company
    
    var body: some View {
        SearchBarView(text: $searchText)
        VStack {
            List(dataService.routes.filter({ route in
                //case insensitive comparison
                return searchText.isEmpty ? true :  route.name.lowercased().contains(searchText.lowercased())
            })) { route in
                NavigationLink(
                    destination: StopsView(dataService: dataService, route: route, color: company.color),
                    label: {
                        RouteCellView(route: route, color: company.color)
                    })
            }
        }
        .onAppear {
            dataService.fetchRoutes(for: company)
        }
        .navigationBarTitle(
            Text("\(company.name) Routes")
        )
    }
}

struct RoutesView_Previews: PreviewProvider {
    static var previews: some View {
        RoutesView(dataService: DataService(), company: K.PREVIEW_COMPANY)
    }
}
