//
//  HexColor.swift
//  ETA Detroit
//
//  Created by admin on 6/8/21.
//

import SwiftUI

/**
 An extension of the SwiftUI color class to allow for an initializer that
 takes a hex string retrieved from the database.
 Modeled from:
 https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor
 */
extension Color {
    
    public init?(hex: String) {
        let r, g, b: Double
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            //database uses 6 digit hex codes
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = Double((hexNumber & 0xff0000) >> 16) / 255
                    g = Double((hexNumber & 0x00ff00) >> 8) / 255
                    b = Double(hexNumber & 0x0000ff) / 255

                    self.init(red: r, green: g, blue: b)
                    return
                }
            }
        }
        
        return nil
    }
    
}
