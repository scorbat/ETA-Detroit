//
//  CompanyCellView.swift
//  ETA Detroit
//
//  Created by admin on 6/4/21.
//

import SwiftUI

struct CompanyCellView: View {
    var body: some View {
        HStack(spacing: 170.0) {
            Image("ddot-logo")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
            Text("DDOT")
                .font(.title2)
        }
        .padding(.horizontal)
    }
}

struct CompanyCellView_Previews: PreviewProvider {
    static var previews: some View {
        CompanyCellView()
    }
}
