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
            ScrollView {
                VStack(spacing: 10) {
                    
                    Image(systemName: "figure.walk")
                        .font(.largeTitle)
                    Text("\(healthStoreVM.currentStepCount) steps")
                    HStack {
                        Text("Goal: 10,000 steps")
                            .font(.caption)
                        Spacer()
                        Text("\(healthStoreVM.stepCountPercent)%")
                            .font(.caption)
                    }
                    //MARK: - Progression Step bar
                    ProgressionStepBar(value: healthStoreVM.currentStepCount, goalValue: 10_000)
                        .padding(.bottom, 20)
                    
                    //MARK: - Quick Snapshot of health variables
                    CurrentSummaryCardView(healthCategory1: "Resting Heart Rate", categoryValue1: "\(healthStoreVM.currentRestHR)")
                    
                    ForEach(healthStoreVM.exerciseTime, id: \.date){
                        ex in
                        Text("\(ex.exerValue)")
                        Text(ex.date, style: .date)
                    }
                }
                .padding(.horizontal)
                .navigationTitle("Health Project App")
                .refreshable {
                    healthStoreVM.calculateStepCountData()
                }
                .onAppear {
                    healthStoreVM.calculateStepCountData()
                    healthStoreVM.calculateRestingHRData()
                    healthStoreVM.calculateExerciseTimeData()
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
