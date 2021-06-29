//
//  SearchBarView.swift
//  ETA Detroit
//
//  Created by admin on 6/29/21.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var text: String
    
    @State private var editing = false
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .onTapGesture {
                    editing = true
                }
            
            if editing {
                Button(action: {
                    editing = false
                    text = ""
                    
                    //dismiss keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                }
                .padding()
            }
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(text: .constant(""))
    }
}
