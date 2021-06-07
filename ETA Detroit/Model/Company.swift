//
//  Company.swift
//  ETA Detroit
//
//  Created by admin on 6/4/21.
//

import Foundation

struct Company: Identifiable {
    
    let name: String
    let imageURL: String
    
    var id: String {
        return name
    }
    
}
