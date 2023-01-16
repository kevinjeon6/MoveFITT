//
//  ContentView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 12/27/22.
//

import Charts
import HealthKit
import SwiftUI

struct ContentView: View {
  
    @ObservedObject var healthStore: HealthStoreViewModel
    
 

    
    var body: some View {
      
      
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    
                    Image(systemName: "figure.walk")
                        .font(.largeTitle)
                    Text("\(healthStore.currentStepCount) steps")
                    HStack {
                        Text("Goal: 10,000 steps")
                            .font(.caption)
                        Spacer()
                        Text("\(healthStore.stepCountPercent)%")
                            .font(.caption)
                    }
                    //MARK: - Progression Step bar
                    ProgressionStepBar(value: healthStore.currentStepCount, goalValue: 10_000)
                        .padding(.bottom, 20)
                    
                    //MARK: - Quick Snapshot of health variables
                    CurrentSummaryCardView(healthCategory1: "Resting Heart Rate", categoryValue1: "\(healthStore.currentRestHR)")
                }
                .padding(.horizontal)
                .navigationTitle("Health Project App")
                .onAppear {
                    healthStore.requestUserAuthorization { success in
                        if success {
                            healthStore.calculateStepCountData()
                            healthStore.calculateRestingHRData()
                        }
                    }
                }
            }
           
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(healthStore: HealthStoreViewModel())
    }
}
