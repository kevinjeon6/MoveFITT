//
//  ExerciseGoalView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/23/23.
//

import SwiftUI

struct ExerciseGoalView: View {
    
    var progress = 80.0
    private let minValue = 0.0
    private let maxValue = 150.0
    
    var body: some View {
      
            
        ZStack {
            RoundedRectangle(cornerRadius: 20)
            .stroke(.blue.opacity(0.7), lineWidth: 3 )
            .frame(width: 400, height: 300)
            .overlay(alignment: .top) {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 400, height: 150)
            }
            
            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "figure.mixed.cardio")
                    Text("Exercise Goal")
                }
                .font(.title2)
                .foregroundColor(.white)
                
                
                Text("150 min/week")
                    .font(.title3)
                    .foregroundColor(.white)
                
            }
            
            VStack {
                HStack(spacing: 80) {
                    ExerciseGaugeView()
                    ExerciseGaugeView()
                }
            }
            .padding(.horizontal, 30)
            
        }
    }
}

struct ExerciseGoalView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseGoalView()
    }
}
