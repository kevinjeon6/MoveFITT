//
//  OneWeekExerciseTimeChartView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/16/23.
//

import Charts
import SwiftUI

struct OneWeekExerciseTimeChartView: View {
    
    @ObservedObject var healthStoreVM: HealthStoreViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text("Exercise Time Average: \(healthStoreVM.exerciseTime.reduce(0, { $0 + $1.exerValue / 7})) mins")
            
            Chart {
                ForEach(healthStoreVM.exerciseTime, id: \.date) {
                    time in
                    
                    BarMark(x: .value("day", time.date, unit: .day),
                             y: .value("RHR", time.exerValue)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(.purple)
                    .symbol(Circle())
                    
                }
            }
            .frame(height: 200)
//            .chartYScale(domain: 30...80)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) {
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.day().month(), centered: true)
                    
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


struct OneWeekExerciseTimeChartView_Previews: PreviewProvider {
    static var previews: some View {
        OneWeekExerciseTimeChartView(healthStoreVM: HealthStoreViewModel())
    }
}
