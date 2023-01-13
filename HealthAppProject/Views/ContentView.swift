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
  
    @StateObject var healthStore = HealthStoreViewModel()
    
 

    
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
                    ProgressionStepBar(value: healthStore.currentStepCount, goalValue: 10_000)
                    
               
                    OneWeekStepChartView(healthStore: healthStore)
                    OneWeekRestHRChartView(healthStore: healthStore)
             
                    Spacer()
                }
                .padding(.horizontal)
                .navigationTitle("Health Project App")
                .onAppear {
                    healthStore.requestUserAuthorization { success in
                        if success {
                            healthStore.calculateHealthData()
                        }
                    }
            }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
