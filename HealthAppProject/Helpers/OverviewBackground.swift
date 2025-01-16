//
//  OverviewBackground.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 11/28/24.
//

import SwiftUI

struct OverviewBackground: ViewModifier {
    
    var borderColor: Color
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(#colorLiteral(red: 0.1353680193, green: 0.1355423033, blue: 0.1408430636, alpha: 1)))
                    .shadow(color: borderColor.opacity(0.1), radius: 10, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(borderColor.opacity(0.2), lineWidth: 2)
            )
    }
 
}

extension View {
    func overviewBackground(borderColor: Color) -> some View {
        modifier(OverviewBackground(borderColor: borderColor))
    }
}


