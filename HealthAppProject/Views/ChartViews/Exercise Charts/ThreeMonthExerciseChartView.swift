//
//  ThreeMonthExerciseChartView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/22/23.
//

import Charts
import SwiftUI

struct ThreeMonthExerciseChartView: View {
//    @ObservedObject var healthStoreVM: HealthStoreViewModel
    var healthKitVM: HealthKitViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Chart {
                ForEach(healthKitVM.exerciseTime3Month, id: \.date) {
                    value in
                    
                    BarMark(x: .value("day", value.date, unit: .weekOfYear),
                             y: .value("ex time", value.value)
                    )
                    .foregroundStyle(.green)
                    .cornerRadius(3)
                }
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks(values: .stride(by: .month )) {
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.month().year())
                }
            }
        }
        .padding(.horizontal)
        
        List {
            ForEach(healthKitVM.exerciseTime3Month.reversed(), id: \.date) { exTime in
                
                DataListView(imageText: "figure.mixed.cardio",
                             imageColor: .green,
                             valueText: "\(exTime.value) min",
                             date: exTime.date)
    
            }
        }
        .listStyle(.inset)
    }
}

struct ThreeMonthExerciseChartView_Previews: PreviewProvider {
    static var previews: some View {
//        ThreeMonthExerciseChartView(healthStoreVM: HealthStoreViewModel())
        ThreeMonthExerciseChartView(healthKitVM: HealthKitViewModel())
    }
}
