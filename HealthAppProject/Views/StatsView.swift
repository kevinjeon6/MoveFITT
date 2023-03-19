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
    
    
    var body: some View {
        
        NavigationStack {
                VStack(spacing: 20){
                    Picker("Choose data", selection: $healthStoreVM.timePeriodSelected.animation(.easeInOut)) {
                            Text("Week").tag("week")
                            Text("Month").tag("month")
                            Text("3 Months").tag("3 months")
                    }
                    .pickerStyle(.segmented)
                    .cornerRadius(8)
                    .padding(.horizontal)
       
            
                    if healthStoreVM.timePeriodSelected == "week" {
                        OneWeekExerciseTimeChartView(healthStoreVM: healthStoreVM)
                    } else if healthStoreVM.timePeriodSelected == "month" {
                        OneMonthExerciseChartView(healthStoreVM: healthStoreVM)
                    } else {
                        ThreeMonthExerciseChartView(healthStoreVM: healthStoreVM)
                    }
                  
                }
                .padding(.horizontal)
                .navigationTitle("Physical Activity")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(healthStoreVM: HealthStoreViewModel())
    }
}
