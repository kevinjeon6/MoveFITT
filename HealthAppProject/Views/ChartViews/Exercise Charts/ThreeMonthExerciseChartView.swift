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
                    
                    BarMark(x: .value("day", value.date, unit: .weekOfYear),
                             y: .value("ex time", value.exerValue)
                    )
                    .foregroundStyle(.green)
                }
            }
            .frame(height: 400)
            .chartXAxis {
                AxisMarks(values: .stride(by: .month )) {
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.month().year())
                }
            }
        }
        .padding(.horizontal)
        
        List {
            ForEach(healthStoreVM.exerciseTime3Months, id: \.date) { exTime in
                VStack(alignment: .leading, spacing: 5){
                    HStack {
                        Image(systemName: "figure.mixed.cardio")
                            .foregroundColor(.green)
                        Text("\(exTime.exerValue)")
                            .font(.title2)
                            .bold()
                    }
                    Text(exTime.date, style: .date)
                        .opacity(0.5)
                }
            }
        }
        
    }
}

struct ThreeMonthExerciseChartView_Previews: PreviewProvider {
    static var previews: some View {
        ThreeMonthExerciseChartView(healthStoreVM: HealthStoreViewModel())
    }
}
