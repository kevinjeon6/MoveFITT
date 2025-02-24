//
//  ProgressionStepBar.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/10/23.
//

import SwiftUI

struct ProgressionStepBar: View {
    
    let value: Int
    let goalValue: Int
    var linearGradientColor: [Color] ///Makes the gradientColor dynamic so you can reuse it 
    
    
    var body: some View {
        
        GeometryReader { geo in
            let progress = min(Double(value) / Double(goalValue), 1.0) //Caps at 100%
            let barWidth = geo.size.width * progress
            
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.black.opacity(0.1))
                    .frame(width: geo.size.width, height: 12)
                
                LinearGradient(
                    gradient: Gradient(
                        colors: linearGradientColor),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .clipShape(Capsule())
                .frame(width: barWidth, height: 12)
            }
        }///End of GeometryReader
        .frame(height: 12)
    }
}

struct ProgressionStepBar_Previews: PreviewProvider {
    
    static var previews: some View {
        ProgressionStepBar(value: 7500, goalValue: 10_000, linearGradientColor: [.mint, .green])
    }
}
