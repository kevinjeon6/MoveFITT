//
//  ExerciseGoalView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/23/23.
//

import SwiftUI

struct ExerciseGoalView: View {
    
    var progress: Double
    var minValue: Double
    var maxValue: Double
    var description: String
    @State private var showInfoSheet = false
    
    var body: some View {
        
        
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.blue.opacity(0.7), lineWidth: 3 )
                .padding(.horizontal)
                .frame(width: 400, height: 200)
                .overlay(alignment: .top) {
                    RoundedRectangle(cornerRadius: 20)
                        .padding(.horizontal)
                        .frame(width: 400, height: 80)
                }
            
            
            
            VStack(spacing: 30) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Image(systemName: "figure.mixed.cardio")
                        Text("Exercise Goal")
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
                    .font(.title2)
                    .foregroundColor(.blue)
                    
                    Text("150 min/week")
                        .font(.title3)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 30)
        
                
                VStack{
                    HStack(spacing: 100) {
                        
                        ExerciseGaugeView(progress: progress, minValue: minValue, maxValue: maxValue, title: "Today")
                        
                        ExerciseGaugeView(progress: progress, minValue: minValue, maxValue: maxValue, title: "Weekly")
                    }
                }
        
                
               
                
            }
        }
    }
}

struct ExerciseGoalView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseGoalView(progress: 75, minValue: 0, maxValue: 100, description: "Text goes Here")
    }
}
