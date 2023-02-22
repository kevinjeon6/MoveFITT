//
//  ContentView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 12/27/22.
//

import HealthKit
import SwiftUI

struct QuickView: View {
  
    @EnvironmentObject var healthStoreVM: HealthStoreViewModel
    @State private var showInfoSheet = false
 
    var body: some View {
      
        NavigationStack {
            GeometryReader { geo in
                ScrollView {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Activity Overview")
                            .padding([.top, .leading], 20)
                            .font(.largeTitle)
                            .bold()
                        
                        
                        VStack (spacing: 10) {
                            HStack(spacing: 50) {
                                ExerciseGaugeView(progress: Double(healthStoreVM.currentExTime), minValue: 0.0, maxValue: Double(healthStoreVM.exerciseDayGoal), title: "Today", dateText: Constants.todayDateString)
                                
      
                                ExerciseGaugeView(progress: Double(healthStoreVM.weeklyExTime),
                                    minValue: 0.0,
                                    maxValue: Double(healthStoreVM.exerciseWeeklyGoal),
                                                  title: "Weekly Total", dateText: Constants.currentWeekDatesString)
                            }
                            .padding(.bottom, 20)
                            
                            
                            StrengthTrainingGoalView(
                                title: "Muscle Strengthening",
                                imageText: "dumbbell.fill",
                                description: HealthInfoText.strengthActivityDescription,
                                goalText: healthStoreVM.muscleWeeklyGoal,
                                color: .purple)
                                .foregroundColor(.black)
                            
                            
                            NavigationLink(value: 1) {
                                StepCountCardView(
                                    progress: Double(healthStoreVM.currentStepCount),
                                    minValue: 0.0,
                                    maxValue: Double(healthStoreVM.stepGoal),
                                    title: "\(healthStoreVM.stepCountPercent)%",
                                    goalText: healthStoreVM.stepGoal)
                                .foregroundColor(.black)
                            }
                          
                            NavigationLink(value: 2) {
                                CurrentSummaryCardView(
                                    title: "Resting HR",
                                    imageText: "heart.fill",
                                    description: HealthInfoText.restHRDescription, color: .red,
                                    categoryValue: "\(healthStoreVM.currentRestHR)")
                                .foregroundColor(.black)
                            }


                            NavigationLink(value: 3) {
                                CurrentSummaryCardView(
                                    title: "Energy Burned",
                                    imageText: "flame.fill",
                                    description: "",
                                    color: .orange,
                                    categoryValue: "\(healthStoreVM.currentKcalsBurned)")
                                .foregroundColor(.black)
                            }
                        }
                        .padding(.top, 30)
                    }
                    .navigationDestination(for: Int.self, destination: { chart in
                        if chart == 1 {
                            OneWeekStepChartView()
                        } else if chart == 2 {
                            OneWeekRestHRChartView()
                        } else if chart == 3 {
                            CaloriesBurnedChartView()
                        }
                    })
                    .frame(minWidth: geo.size.width * 0.8, maxWidth: .infinity)
                    .padding(.horizontal)
                   
                }
            }
        }
    }
}

struct QuickView_Previews: PreviewProvider {
    static var previews: some View {
        QuickView()
            .environmentObject(HealthStoreViewModel())
    }
}
