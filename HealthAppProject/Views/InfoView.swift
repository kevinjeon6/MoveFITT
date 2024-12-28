//
//  InfoView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/18/23.
//

import SwiftUI

struct InfoView: View {
    
    
    var body: some View {
        ZStack {
            Color.primary.ignoresSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 10) {
                Group {
                    Text("Step Goal")
                        .modifier(GoalTextModifier())
                    
                    Text(HealthInfoText.stepCountDescription)

                    
                    Text("Daily Exercise Goal")
                        .modifier(GoalTextModifier())
                    Text(HealthInfoText.exerTimeDescription)
         
                    
                    Text("Weekly Exercise Goal")
                        .modifier(GoalTextModifier())
                    Text(HealthInfoText.weeklyExerciseTimeDescription)
       
                    Text("Strength Goal")
                        .modifier(GoalTextModifier())
                    Text(HealthInfoText.strengthGoalDescription)
                }
                .foregroundStyle(.white)
                
                Spacer()
                HStack {
                    Spacer()
                    Link(destination: URL(string: "https://health.gov/sites/default/files/2019-09/Physical_Activity_Guidelines_2nd_edition.pdf")!) {
                        
                        Text("Physical Activity Guidelines for Americans, 2nd edition")
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                    }
                }
            }
            .padding()
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
