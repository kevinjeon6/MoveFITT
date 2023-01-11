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
    var color1: Color = .mint
    var color2: Color = .green
   
    
    
    var body: some View {
     
        ZStack(alignment: .leading) {
            
            Capsule()
                .fill(Color.black.opacity(0.1))
                .frame(height: 18)
            
            
          
                Capsule()
                    .trim(from: 0, to: CGFloat(self.value) / CGFloat(self.goalValue))
                    .frame(width: 250, height: 18)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [color1, color2]), startPoint: .leading, endPoint: .trailing).clipShape(Capsule())
                    )
                    .foregroundColor(.clear)
                 
        }
       
    }
}

struct ProgressionStepBar_Previews: PreviewProvider {
    

    static var previews: some View {
        ProgressionStepBar(value: 2,goalValue: 500, color1: .mint, color2: .green)
    }
}
