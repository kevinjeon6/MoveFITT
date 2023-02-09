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
            
            
            Text("Exercise Time Average: \(healthStoreVM.weeklyExTime / 7) mins")

            
            Chart {
                ForEach(healthStoreVM.exerciseTime7Days, id: \.date) {
                    time in
                    
                    BarMark(x: .value("day", time.date, unit: .day),
                             y: .value("ex time", time.exerValue)
                    )
                    .foregroundStyle(.green)   
                }
            }
            .frame(height: 400)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) {
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.day().month(), centered: true)
                    
                }
            }
        }
        .padding(.horizontal)
        
        List{
            ForEach(healthStoreVM.exerciseTime7Days, id: \.date) { exTime in
                VStack(alignment: .leading, spacing: 5) {
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


struct OneWeekExerciseTimeChartView_Previews: PreviewProvider {
    static var previews: some View {
        OneWeekExerciseTimeChartView(healthStoreVM: HealthStoreViewModel())
    }
}
