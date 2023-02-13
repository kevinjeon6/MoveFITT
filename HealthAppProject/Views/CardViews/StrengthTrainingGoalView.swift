//
//  ExerciseGoalView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/23/23.
//

import SwiftUI

struct StrengthTrainingGoalView: View {
    
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
                            Text(title)
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
    
                ProgressGaugeView(progress: 2, minValue: 0, maxValue: 3, scaleValue: 1.5, gaugeColor: .purple, title: "2")
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 20)
            .frame(width: 350, height: 200)
        }
    }
}

struct StrengthTrainingGoalView_Previews: PreviewProvider {
    static var previews: some View {
        StrengthTrainingGoalView(title: "Muscle Strength Goal", imageText: "dumbbell.fill", description: "Train 2x/week", goalText: 3, color: .purple)
    }
}
