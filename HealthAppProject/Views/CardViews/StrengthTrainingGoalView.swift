//
//  ExerciseGoalView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/23/23.
//

import SwiftUI

struct StrengthTrainingGoalView: View {
    
    var progress: Double
    var minValue: Double
    var maxValue: Double
    var title: Int
    var goalText: Int
    var color: Color
    var guidelines: Int = 2
    
    var meetGoal: Bool {
        if title >= guidelines {
            return true
        } else {
            return false
        }
    }
    
    
    var body: some View {
        
        HStack(spacing: 30) {
            VStack {
                VStack(alignment: .leading) {
                    Text("Strength training")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                    Text("Your goal: \(title) / \(goalText) workouts")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .padding(.bottom, 10)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                    Text("Meet the guidelines?")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                    HStack {
                        Text("\(title) / \(guidelines) ")
                            .foregroundColor(.primary)
                        Image(systemName: meetGoal ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(meetGoal ? .green : .primary)
                    }
                    .font(.subheadline)
                }
            }

            Spacer()
            ProgressGaugeView(
                progress: progress,
                minValue: minValue,
                maxValue: maxValue,
                scaleValue: 1.5,
                gaugeColor: color,
                title: title)
            Spacer()
        }
        .frame(width: nil)
        .padding()
        .cardBackground()

    }
}

struct StrengthTrainingGoalView_Previews: PreviewProvider {
    static var previews: some View {
        StrengthTrainingGoalView(progress: 2, minValue: 0, maxValue: 3, title: 2, goalText: 3, color: .purple)
    }
}
