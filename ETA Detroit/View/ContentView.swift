//
//  ContentView.swift
//  ETA Detroit
//
//  Created by admin on 6/3/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    private let companies: [Company] = DataService.shared.fetchCompanies()

    var body: some View {
        ZStack {
            List {
                ForEach(companies) { company in
                    CompanyCellView(
                        name: company.name,
                        imageURL: company.imageURL
                    )
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
