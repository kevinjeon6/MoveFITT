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
        
        
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.purple.opacity(0.7), lineWidth: 3 )
                .padding(.horizontal)
                .frame(width: 400, height: 200)
   
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: imageText)
                                .foregroundColor(color)
                            Text("Strength Training")
                                .font(.title2)
                            Spacer()
                            Button {
                                showInfoSheet.toggle()
                            } label: {
                                Image(systemName: "info.circle")
                            }
                            .sheet(isPresented: $showInfoSheet){
                                InfoView(description: description)
                                    .presentationDetents([.medium])
                            }
                        }
                    
                    Text("Goal is to perform ") + Text("\(goalText) ").bold() + Text("muscle strengthening activities this week")
                }
                .padding(.bottom, 20)
    
                ProgressGaugeView(progress: progress, minValue: minValue, maxValue: maxValue, scaleValue: 1.5, gaugeColor: .purple, title: title)
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 20)
            .frame(width: 350, height: 200)
        }
    }
}

struct StrengthTrainingGoalView_Previews: PreviewProvider {
    static var previews: some View {
        StrengthTrainingGoalView(progress: 2, minValue: 0, maxValue: 3, title: "2", imageText: "dumbbell.fill", description: "ad", goalText: 3, color: .purple)
    }
}
