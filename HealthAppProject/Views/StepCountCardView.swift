//
//  StepCountCardView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/27/23.
//

import SwiftUI

struct StepCountCardView: View {
    var progress: Double
    var minValue: Double
    var maxValue: Double
    var title: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 5)
                .padding(.horizontal)
                .frame(width: 400, height: 80)
            
            HStack(spacing: 30){
    
                VStack (alignment: .leading, spacing: 0) {
                    StepCountGaugeView(progress: progress, minValue: minValue, maxValue: maxValue, title: title)
                        .padding(.top, 5)
                    Text("Goal: 10,000 steps")
                        .font(.caption)
                        .padding(.bottom, 5)
                }

                
                Text("\(Int(progress)) steps")
                    .font(.title)
                    .bold()
            }
            .padding(.trailing, 30)
        }
    }
}

struct StepCountCardView_Previews: PreviewProvider {
    static var previews: some View {
        StepCountCardView(progress: 3500, minValue: 0, maxValue: 10_000, title: "35%")
    }
}
