//
//  OneMonthExerciseChartView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/20/23.
//

import Charts
import SwiftUI

struct OneMonthExerciseChartView: View {
    @ObservedObject var healthStoreVM: HealthStoreViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Chart {
                ForEach(healthStoreVM.exerciseTimeMonth, id: \.date) {
                    time in
                    
                    BarMark(x: .value("day", time.date, unit: .day),
                             y: .value("ex time", time.exerValue)
                    )
                    .foregroundStyle(.green.gradient)
                    .cornerRadius(2)
                }
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks(values: .automatic(minimumStride: 7)) {
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.day().month())
                    
                }
            }
        }
        .padding(.horizontal)
        
        List {
            ForEach(healthStoreVM.exerciseTimeMonth.reversed(), id: \.date) { exTime in
                
                DataListView(imageText: "figure.mixed.cardio",
                             imageColor: .green,
                             valueText: "\(exTime.exerValue) min",
                             date: exTime.date)
                
            }
        }
        .listStyle(.inset)
    }
}

struct OneMonthExerciseChartView_Previews: PreviewProvider {
    static var previews: some View {
        OneMonthExerciseChartView(healthStoreVM: HealthStoreViewModel())
    }
}
