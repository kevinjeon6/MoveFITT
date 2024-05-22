//
//  OneWeekExerciseTimeChartView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/16/23.
//

import Charts
import SwiftUI

struct OneWeekExerciseTimeChartView: View {
    
//    @ObservedObject var healthStoreVM: HealthStoreViewModel
//    @Environment(HealthKitViewModel.self) var healthKitVM
    var healthKitVM: HealthKitViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text("Exercise Time Average: \(Int(healthKitVM.chartAverageExTime)) mins")

            Chart {
                ForEach(healthKitVM.exerciseTimeData, id: \.date) {
                    time in
                    
                    BarMark(x: .value("day", time.date, unit: .day),
                             y: .value("ex time", time.value)
                    )
                    .foregroundStyle(.green.gradient)
                    .cornerRadius(5)
                }
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) {
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.day().month(), centered: true)
                    
                }
            }
        }
        .padding(.horizontal)
        
        List{
            ForEach(healthKitVM.exerciseTimeData.reversed(), id: \.date) { exTime in
                
                DataListView(imageText: "figure.mixed.cardio",
                             imageColor: .green,
                             valueText: exTime.value,
                             unitText: "min",
                             date: exTime.date)
                
            }
        }
        .listStyle(.inset)
        
    }
}


struct OneWeekExerciseTimeChartView_Previews: PreviewProvider {
    static var previews: some View {
//        OneWeekExerciseTimeChartView(healthStoreVM: HealthStoreViewModel())
       OneWeekExerciseTimeChartView(healthKitVM: HealthKitViewModel())
    }
}
