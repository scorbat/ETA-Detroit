//
//  CompanyCellView.swift
//  ETA Detroit
//
//  Created by admin on 6/4/21.
//

import SwiftUI

struct CompanyCellView: View {
    
    let name: String
    let imageURL: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(imageURL)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 75, alignment: .center)
            Text(name)
                .font(.title2)
        }
        .padding(.horizontal)
    }
}

struct CompanyCellView_Previews: PreviewProvider {
    static var previews: some View {
        CompanyCellView(name: "DDOT", imageURL: "ddot-logo")
    }
}
