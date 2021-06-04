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
    
    var companies: [Company]? = nil

    var body: some View {
        ZStack {
            List {
                Button(action: {
                    
                    for company in companies {
                        print(company.name)
                    }
                }) {
                    CompanyCellView()
                }
            }
        }
        .onAppear {
            self.companies = DataService.shared.fetchCompanies()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
