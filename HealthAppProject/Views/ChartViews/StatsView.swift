//
//  StatsView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/15/23.
//

import Charts
import SwiftUI

struct StatsView: View {
    
    @ObservedObject var healthStoreVM: HealthStoreViewModel
    
    @State private var week = "Week"
    let dateSegments = ["Week", "Month", "3 Months"]
    
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack(spacing: 20){
                    Picker("Choose data", selection: $week) {
                        ForEach(dateSegments, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .cornerRadius(8)
                    .padding(.horizontal)
                    
                    
                    OneWeekStepChartView(healthStoreVM: healthStoreVM)
                    OneWeekRestHRChartView(healthStoreVM: healthStoreVM)
                    OneWeekExerciseTimeChartView(healthStoreVM: healthStoreVM)
                }
                .padding(.horizontal)
                .navigationTitle("Charts")
            }
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(healthStoreVM: HealthStoreViewModel())
    }
}
