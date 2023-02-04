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
                    VStack(spacing: 5) {

                            Text(Constants.currentWeekDatesString)
                                .padding(.top, 40)
                                .font(.title)
                            .bold()
                        
                        
                        HStack(spacing: 50) {
                            ExerciseGaugeView(progress: Double(healthStoreVM.currentExTime), minValue: 0.0, maxValue: Double(healthStoreVM.exerciseDayGoal), title: "Today")
                            
  
                            ExerciseGaugeView(progress: Double(healthStoreVM.weeklyExTime),
                                minValue: 0.0,
                                maxValue: Double(healthStoreVM.exerciseWeeklyGoal),
                                title: "Weekly")
                        }
                        .padding(.top, 20)
                   
                        VStack (spacing: 5) {
                            
                            
                            NavigationLink {
                                OneWeekStepChartView()
                            } label: {
                                StepCountCardView(
                                    progress: Double(healthStoreVM.currentStepCount),
                                    minValue: 0.0,
                                    maxValue: Double(healthStoreVM.stepGoal),
                                    title: "\(healthStoreVM.stepCountPercent)%",
                                    goalText: healthStoreVM.stepGoal)
                                .foregroundColor(.black)
                            }
                            .toolbar(.hidden)
                          

                           
                            NavigationLink {
                               OneWeekRestHRChartView()
                            } label: {
                                CurrentSummaryCardView(
                                    title: "Resting HR",
                                    imageText: "heart.fill",
                                    description: healthStoreVM.restHRDescription, color: .red,
                                    categoryValue: "\(healthStoreVM.currentRestHR)")
                                .foregroundColor(.black)
                            }

                            NavigationLink {
                                CaloriesBurnedChartView()
                            } label: {
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
    }
}
