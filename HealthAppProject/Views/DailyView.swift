//
//  DailyView.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 11/14/24.
//

import SwiftUI

struct DailyView: View {
    
    var imageText: String
    var imageColor: Color
    var metricText: String
    var currentValue: Int
    var goalText: Int
    var goalPercent: Int
    var gradientColor: [Color]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: imageText)
                    .foregroundStyle(imageColor)
                    
                Text("\(currentValue) / \(goalText) \(metricText)")
                    .minimumScaleFactor(0.1)
                Spacer()
                Text("\(goalPercent)%")
            }

            ProgressionStepBar(value: currentValue, goalValue: goalText, linearGradientColor: gradientColor)
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    DailyView(imageText: "figure.walk", imageColor: .cyan, metricText: "steps", currentValue: 7_000, goalText: 10_000, goalPercent: 100, gradientColor: [.cyan, .blue])
}
