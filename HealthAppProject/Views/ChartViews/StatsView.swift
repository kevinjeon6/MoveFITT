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
            ScrollView {
                VStack(spacing: 20){
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
