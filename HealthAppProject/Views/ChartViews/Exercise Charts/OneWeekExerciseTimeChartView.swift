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
            
            
            Text("Exercise Time Average: \(healthStoreVM.chartAverageExTime) mins")

            
            Chart {
                ForEach(healthStoreVM.exerciseTime7Days, id: \.date) {
                    time in
                    
                    BarMark(x: .value("day", time.date, unit: .day),
                             y: .value("ex time", time.exerValue)
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
            ForEach(healthStoreVM.exerciseTime7Days.reversed(), id: \.date) { exTime in
                
                DataListView(imageText: "figure.mixed.cardio",
                             imageColor: .green,
                             valueText: "\(exTime.exerValue) min",
                             date: exTime.date)
                
            }
        }
        .listStyle(.inset)
        
    }
}


struct OneWeekExerciseTimeChartView_Previews: PreviewProvider {
    static var previews: some View {
        OneWeekExerciseTimeChartView(healthStoreVM: HealthStoreViewModel())
    }
}
