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
    var title: String
    var imageText: String
    var description: String
    var goalText: Int
    var color: Color
    
    
    
    @State private var showInfoSheet = false
    
    var body: some View {
        
        HStack(spacing: 30) {
            VStack {
                VStack(alignment: .leading) {
                    Text("Strength training")
                        .font(.title2)
                    Text("Your goal: \(title) / \(goalText) workouts")
                        .font(.footnote)
                        .padding(.bottom, 10)
                    Text("Meet the guidelines?")
                        .font(.headline)
                    HStack {
                        Text("\(title)/2 ")
                            .font(.footnote)
                        Image(systemName: "circle")
                            .font(.footnote)
                    }
                }
            }
            .padding(.leading, 20)
            Spacer()
            ProgressGaugeView(
                progress: progress,
                minValue: minValue,
                maxValue: maxValue,
                scaleValue: 1.5,
                gaugeColor: .purple,
                title: title)
            Spacer()
        }
        .padding(.trailing)
    }
}

struct StrengthTrainingGoalView_Previews: PreviewProvider {
    static var previews: some View {
        StrengthTrainingGoalView(progress: 2, minValue: 0, maxValue: 3, title: "2", imageText: "dumbbell.fill", description: "ad", goalText: 3, color: .purple)
    }
}
