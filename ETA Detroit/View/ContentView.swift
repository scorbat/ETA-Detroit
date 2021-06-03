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

    var body: some View {
        ZStack {
            List {
                Button(action: {
                    
                }) {
                    Text("Test Button")
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
