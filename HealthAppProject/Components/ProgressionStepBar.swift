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
    var color1: Color = .cyan
    var color2: Color = .blue
   
    
    
    var body: some View {
     
        GeometryReader { geo in
            VStack {
                ZStack(alignment: .leading) {
                    
                    Capsule()
                        .fill(Color.black.opacity(0.1))
                        .frame(height: 12)
                    
                    LinearGradient(gradient: Gradient(colors: [color1, color2]), startPoint: .leading, endPoint: .trailing)
                        .clipShape(Capsule())
                        .frame(width: geo.size.width * CGFloat(value) / CGFloat(goalValue))
                }
            }
            .frame(width: geo.size.width * 0.9, height: 12)
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

struct ProgressionStepBar_Previews: PreviewProvider {
    

    static var previews: some View {
        ProgressionStepBar(value: 7500, goalValue: 10_000, color1: .mint, color2: .green)
    }
}
