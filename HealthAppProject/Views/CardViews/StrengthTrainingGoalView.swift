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
    var color: Color
    
    @State private var showInfoSheet = false
    
    var body: some View {
        
        
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.purple.opacity(0.7), lineWidth: 3 )
                .padding(.horizontal)
                .frame(width: 400, height: 200)
   
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
                  
                Spacer()
            }
            .padding(.trailing, 10)
            .padding(.leading)
            .padding(.top)
            .frame(width: 350, height: 200)
            VStack(alignment: .center) {
                ProgressGaugeView(progress: 2, minValue: 0, maxValue: 3, scaleValue: 2.0, gaugeColor: .purple,
                                   title: "2")
                    .padding(.top, 40)
            }
        }
    }
}

struct StrengthTrainingGoalView_Previews: PreviewProvider {
    static var previews: some View {
        StrengthTrainingGoalView(title: "Muscle Strength Goal", imageText: "dumbbell.fill", description: "Train 2x/week", color: .purple)
    }
}
