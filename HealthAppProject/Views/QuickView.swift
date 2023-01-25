//
//  ContentView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 12/27/22.
//

import Charts
import HealthKit
import SwiftUI

struct QuickView: View {
  
    @ObservedObject var healthStoreVM: HealthStoreViewModel
    
 
    var body: some View {
      
        NavigationStack {
            GeometryReader { geo in
                ScrollView {
                    VStack(spacing: 10) {
                        
                        
                        ExerciseGoalView(progress: Double(healthStoreVM.currentExTime), minValue: 0.0, maxValue: Double(healthStoreVM.exerciseWeeklyGoal), description: healthStoreVM.exerTimeDescription)
                        
                        
                        
                        Image(systemName: "figure.walk")
                            .font(.largeTitle)
                        Text("\(healthStoreVM.currentStepCount) steps")
                        HStack {
                            Text("Goal: \(healthStoreVM.stepGoal)steps")
                                .font(.caption)
                            Spacer()
                            Text("\(healthStoreVM.stepCountPercent)%")
                                .font(.caption)
                        }
                        //MARK: - Progression Step bar
                        ProgressionStepBar(value: healthStoreVM.currentStepCount, goalValue: healthStoreVM.stepGoal)
                            .padding(.bottom, 20)
                        
                        //MARK: - Quick Snapshot of health variables
                  
                                CurrentSummaryCardView(
                                    title: "Resting HR",
                                    description: healthStoreVM.restHRDescription,
                                    categoryValue: "\(healthStoreVM.currentRestHR)"
                                )
                    }
                    .frame(minWidth: geo.size.width * 0.8, maxWidth: .infinity)
                    .padding(.horizontal)
                    .navigationTitle("Health Project App")
                }
             
            }
        }
    }
}

struct QuickView_Previews: PreviewProvider {
    static var previews: some View {
        QuickView(healthStoreVM: HealthStoreViewModel())
    }
}
