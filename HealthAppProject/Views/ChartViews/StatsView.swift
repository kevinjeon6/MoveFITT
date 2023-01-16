//
//  StatsView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/15/23.
//

import SwiftUI

struct StatsView: View {
    
    @ObservedObject var healthStoreVM: HealthStoreViewModel
    
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20){
                OneWeekStepChartView(healthStore: healthStoreVM)
                OneWeekRestHRChartView(healthStore: healthStoreVM)
            }
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(healthStoreVM: HealthStoreViewModel())
    }
}
