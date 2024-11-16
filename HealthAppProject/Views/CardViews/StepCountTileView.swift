//
//  StepCountTileView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 3/2/23.
//

import SwiftUI

struct StepCountTileView: View {
    var currentValue: Int
    var goalText: Int
    var stepPercent: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "figure.walk")
                    .foregroundColor(.cyan)
                Text("Steps")
                Spacer()
                Image(systemName: "chevron.forward")
            }
            
            Text("\(currentValue)")
            Text("Goal: \(goalText) steps")
                .minimumScaleFactor(0.1)
            HStack {
                ProgressionStepBar(value: currentValue, goalValue: goalText, linearGradientColor: [.cyan, .blue])
                Text("\(stepPercent)%")
                    .layoutPriority(1)
            }
            
        }
        .padding()
        .frame(width: nil, height: 145)
        .cardBackground()
 
    }
}

struct StepCountTileView_Previews: PreviewProvider {
    static var previews: some View {
        StepCountTileView(currentValue: 10_000, goalText: 10_000, stepPercent: 100)
            .previewDevice("iPhone SE")
    }
}
