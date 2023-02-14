//
//  OneWeekChartView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/13/23.
//

import Charts
import SwiftUI

struct OneWeekStepChartView: View {
  @EnvironmentObject var healthStoreVM: HealthStoreViewModel

    
    var body: some View {

            VStack(alignment: .leading, spacing: 10) {
                //reduce adds up the total count
                Text("Average: \(healthStoreVM.averageStepCount) steps")
                    .font(.headline)

                Chart {
                    ForEach(healthStoreVM.steps, id: \.date) {
                        stepData in

                        BarMark(x: .value("day", stepData.date, unit: .day),
                                 y: .value("steps", stepData.count)
                        )
                        .foregroundStyle(.cyan.gradient)
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
            ForEach(healthStoreVM.steps.reversed(), id: \.date) {
                step in
                
                DataListView(imageText: "figure.walk",
                             imageColor: .cyan,
                             valueText: "\(step.count) steps",
                             date: step.date)
            }
        }
        .listStyle(.inset)
        
    }
}

struct OneWeekChartView_Previews: PreviewProvider {
    static var previews: some View {
        OneWeekStepChartView()
            .environmentObject(HealthStoreViewModel())
    }
}
