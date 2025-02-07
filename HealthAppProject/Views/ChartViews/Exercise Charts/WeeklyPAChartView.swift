//
//  WeeklyPAChartView.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 12/3/24.
//

import Charts
import SwiftUI

struct WeeklyPAChartView: View {
    
    var metricData: [HealthMetric]
    
    
    var body: some View {
        Chart(metricData, id: \.date) { sample in
            
            BarMark(
                x: .value( "day",sample.date,unit: .day),
                y: .value("ex time",sample.value)
            )
            .foregroundStyle(.green)
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
    }
}

#Preview {
    WeeklyPAChartView(metricData: MockData.exerciseTime)
}
