//
//  GoalTextModifier.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 3/30/23.
//

import SwiftUI

struct GoalTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .underline()
            .bold()
    }
}
