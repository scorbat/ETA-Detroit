//
//  ContentView.swift
//  ETA Detroit
//
//  Created by admin on 6/3/21.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var dataService = DataService()

    var body: some View {
        NavigationView {
            VStack {
                Text("ETA Detroit")
                    .font(.title)
                List {
                    ForEach(dataService.companies) { company in
                        NavigationLink(
                            destination: RoutesView(dataService: dataService, company: company),
                            label: {
                                CompanyCellView(
                                    name: company.name,
                                    imageURL: company.imageURL
                                )
                            })
                    }
                }
            }
        }
        .onAppear {
            dataService.fetchCompanies()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
