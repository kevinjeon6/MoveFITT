//
//  ShapeExtension.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 1/28/25.
//

import Foundation
import SwiftUI

extension Shape {
    func dayOutline(isToday: Bool, lineWidth: CGFloat = 1, trim: CGFloat = 1) -> some View {
        let gradientColors = Gradient(colors: [.pink, .purple])
        let linearGradient = LinearGradient(gradient: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing)
        
        return self
            .trim(from: 0, to: trim)
            .stroke(isToday ? AnyShapeStyle(linearGradient) : AnyShapeStyle(.clear), style: StrokeStyle(lineWidth: lineWidth, lineCap: CGLineCap.round))
            .padding(lineWidth/2 + 5)
    }
}
