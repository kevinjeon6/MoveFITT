//
//  FitnessIconModifier.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 3/22/23.
//

import SwiftUI

struct FitnessIconModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .imageScale(.large)
            .foregroundColor(.green)
            .background(
                Circle()
                    .fill(.green.opacity(0.3))
                    .frame(width: 50, height: 50)
                )
        
    }
}


