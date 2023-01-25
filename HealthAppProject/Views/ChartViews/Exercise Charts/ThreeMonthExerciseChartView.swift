//
//  ThreeMonthExerciseChartView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/22/23.
//

import Charts
import SwiftUI

struct ThreeMonthExerciseChartView: View {
    @ObservedObject var healthStoreVM: HealthStoreViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Chart {
                ForEach(healthStoreVM.exerciseTime3Months, id: \.date) {
                    value in
                    
                    BarMark(x: .value("day", value.date, unit: .day),
                             y: .value("ex time", value.exerValue)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(.purple)
                    .symbol(Circle())
                }
            }
            .frame(height: 400)
            .chartXAxis {
                AxisMarks(values: .automatic(minimumStride: 30)) {
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.day().month())
                    
                }
            }
            .chartPlotStyle { plotContent in
                plotContent
                    .background(.purple.opacity(0.1))
                    .border(.mint, width: 1)
            }
        }
        .padding(.horizontal)
    }
}

struct ThreeMonthExerciseChartView_Previews: PreviewProvider {
    static var previews: some View {
        ThreeMonthExerciseChartView(healthStoreVM: HealthStoreViewModel())
    }
}
