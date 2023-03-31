//
//  InfoView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/18/23.
//

import SwiftUI

struct InfoView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 20) {
                
                InfoHeaderComponent()
                    .frame(maxWidth: .infinity)
                
                Group {
                    Text("Step Goal")
                        .modifier(GoalTextModifier())
                    
                    Text(HealthInfoText.stepCountDescription)
                        .foregroundColor(.primary)
                    
                    Text("Daily Exercise Goal")
                        .modifier(GoalTextModifier())
                    Text(HealthInfoText.exerTimeDescription)
                        .foregroundColor(.primary)
                    
                    Text("Weekly Exercise Goal")
                        .modifier(GoalTextModifier())
                    Text(HealthInfoText.weeklyExerciseTimeDescription)
                        .foregroundColor(.primary)
                    
                    
                    Text("Strength Goal")
                        .modifier(GoalTextModifier())
                    Text(HealthInfoText.strengthGoalDescription)
                }
               
                
                Spacer()
                HStack {
                    Spacer()
                    Text(" Physical Activity Guidelines for Americans, 2nd edition")
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                }
                
            }
            .padding(.top, 25)
            .padding()
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
