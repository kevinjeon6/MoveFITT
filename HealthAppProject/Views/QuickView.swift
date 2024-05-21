//
//  ContentView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 12/27/22.
//

import HealthKit
import SwiftUI

struct QuickView: View {
  
    @Environment(HealthKitViewModel.self) var healthKitVM
    @EnvironmentObject var settingsVM: SettingsViewModel

    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    
    ]
 
    var body: some View {
      
        NavigationStack {
            GeometryReader { geo in
                ScrollView {
                    VStack(alignment: .leading, spacing: 5) {
                        VStack (spacing: 10) {
                            HStack(spacing: 50) {
                                ExerciseGaugeView(
                                    progress: healthKitVM.mostRecentExerciseTime,
                                    minValue: 0.0,
                                    maxValue: Double(settingsVM.exerciseDayGoal),
                                    title: "Today",
                                    dateText: Constants.todayDateString
                                )
                                
      
                                ExerciseGaugeView(
                                    progress:
                                        healthKitVM.weeklyExTime,
                                    minValue: 0.0,
                                    maxValue: Double(
                                        settingsVM.exerciseWeeklyGoal
                                    ),
                                    title: "Weekly Total",
                                    dateText: Constants.currentWeekDatesString
                                )
                            }
                            .padding(.bottom, 20)
                            
                         
                            StrengthTrainingGoalView(
                                progress: Double(healthKitVM.strengthActivityWeekCount.count),
                                minValue: 0.0,
                                maxValue: Double(settingsVM.muscleWeeklyGoal),
                                title: healthKitVM.strengthActivityWeekCount.count,
                                goalText: settingsVM.muscleWeeklyGoal,
                                color: .green
                            )
                            
                            StrengthActivityWeekView()

            
                            LazyVGrid(columns: columns, spacing: 10) {
                                NavigationLink(value: 1) {
                                    StepCountTileView(currentValue: Int(healthKitVM.currentStepCount), goalText: settingsVM.stepGoal, stepPercent: (Int(healthKitVM.currentStepCount) * 100) / settingsVM.stepGoal)
                                        
                                }
                                .foregroundColor(.primary)
                                .accessibilityAddTraits(.isLink)
             
                                
                                NavigationLink(value: 3) {
                                    HealthInfoTileView(title: "Energy Burned", imageText: "flame.fill", color: .orange, healthValue: Int(healthKitVM.currentKcalsBurned))
                                }
                                .foregroundColor(.primary)
                                .accessibilityAddTraits(.isLink)
                      
                                
                                NavigationLink(value: 2) {
                                    HealthInfoTileView(title: "Resting HR", imageText: "heart.fill", color: .red, healthValue: Int(healthKitVM.currentRestHR))
                                }
                                .foregroundColor(.primary)
                                .accessibilityAddTraits(.isLink)
                                
                                NavigationLink(value: 4) {
                                    HealthInfoTileView(title: "HRV", imageText: "waveform.path.ecg", color: .red, healthValue: Int(healthKitVM.currentHRV))
                                }
                                .foregroundColor(.primary)
                                .accessibilityAddTraits(.isLink)
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
                        } else {
                            OneWeekHRVChartView()
                        }
                    })
                    .frame(minWidth: geo.size.width * 0.8, maxWidth: .infinity)
                    .padding(.horizontal)
                   
                }
                .navigationTitle("Activity Overview")
                .task {
                   await healthKitVM.displayData()
                }
            }
        }
    }
}

struct QuickView_Previews: PreviewProvider {
    static var previews: some View {
        QuickView()
            .environment(HealthKitViewModel())
    }
}
