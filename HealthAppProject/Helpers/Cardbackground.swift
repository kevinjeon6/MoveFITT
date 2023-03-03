//
//  Cardbackground.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 3/2/23.
//

import Foundation

import SwiftUI

struct Cardbackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.darkModeColor)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.2), radius: 4)
    }
}



extension View {
    func cardBackground() -> some View {
        modifier(Cardbackground())
    }
}
