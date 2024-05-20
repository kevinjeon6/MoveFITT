//
//  StatsView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/15/23.
//

import Charts
import SwiftUI

struct StatsView: View {
    
    @Environment(HealthKitViewModel.self) var healthKitVM
    @State private var timePeriodSelected = "week"
    
    var body: some View {
        
        NavigationStack {
                VStack(spacing: 20){
                    Picker("Choose data", selection: $timePeriodSelected.animation(.easeInOut)) {
                            Text("Week").tag("week")
                            Text("Month").tag("month")
                            Text("3 Months").tag("3 months")
                    }
                    .pickerStyle(.segmented)
                    .cornerRadius(8)
                    .padding(.horizontal)
       
            
                    if timePeriodSelected == "week" {
                        OneWeekExerciseTimeChartView(healthKitVM: healthKitVM)
                       
                    } else if timePeriodSelected == "month" {
                        OneMonthExerciseChartView(healthKitVM: healthKitVM)
                        
                    } else {
                        ThreeMonthExerciseChartView(healthKitVM: healthKitVM)
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
        StatsView()
            .environment(HealthKitViewModel())
    }
}
