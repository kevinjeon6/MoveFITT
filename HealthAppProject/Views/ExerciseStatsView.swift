//
//  ExerciseStatsView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/15/23.
//

import Charts
import SwiftUI

enum TimeSelected: CaseIterable, Identifiable {
    
    var id: Self { self }
    
    case sevenDays
    case thirtyDays
    case sixtyDays
    
    var title: String {
        switch self {
        case .sevenDays:
            "7 days"
        case .thirtyDays:
            "30 days"
        case .sixtyDays:
            "60 days"
        }
    }
    
}

struct ExerciseStatsView: View {
    
    @Environment(HealthKitViewModel.self) var healthKitVM
    @State private var timePeriodSelected: TimeSelected = .sevenDays
    
    var body: some View {
        
        NavigationStack {
                VStack(spacing: 20){
                    Picker("Choose data", selection: $timePeriodSelected.animation(.easeInOut)) {
                        ForEach(TimeSelected.allCases) {
                            Text($0.title)
                        }
                    }
                    .pickerStyle(.segmented)
                    .cornerRadius(8)
                    .padding(.horizontal)
       
                    switch timePeriodSelected {
                    case .sevenDays:
                        OneWeekExerciseTimeChartView(healthKitVM: healthKitVM)
                    case .thirtyDays:
                        OneMonthExerciseChartView(healthKitVM: healthKitVM)
                    case .sixtyDays:
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
        ExerciseStatsView()
            .environment(HealthKitViewModel())
    }
}
