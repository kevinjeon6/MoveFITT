//
//  WeeklyView.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 11/15/24.
//

import SwiftUI

struct WeeklyView: View {
    
    var progress: Double
    var minValue: Double
    var maxValue: Double
    var title: Int
    var color: Color
    
    var body: some View {
        
        HStack(spacing: 30){
            VStack(alignment: .leading, spacing: 4) {
                Text("Strength Traning")
                    .font(.title2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                
                HStack {
                    Text("Goal: 0/2")
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                }
                .font(.subheadline)
                .padding(.bottom)
                
                Text("Physical Activity")
                    .font(.title2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                
                HStack {
                    Text("200/350")
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                }
                .font(.subheadline)
            }
            
            Spacer()
            ProgressGaugeView(
                progress: progress,
                minValue: minValue,
                maxValue: maxValue,
                scaleValue: 1.9,
                gaugeColor: color,
                title: title)
            
            Spacer()
        }
        .padding(.bottom, 32)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    WeeklyView(progress: 2, minValue: 0, maxValue: 3, title: 2, color: .green)
}
