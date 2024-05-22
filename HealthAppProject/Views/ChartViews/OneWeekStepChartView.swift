//
//  OneWeekChartView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/13/23.
//

import Charts
import SwiftUI

struct OneWeekStepChartView: View {

    @Environment(HealthKitViewModel.self) var healthKitVM
    
    
    private var steps: [HealthMetricValue] {
        healthKitVM.stepData.sorted { lhs, rhs in
            lhs.date > rhs.date
        }
    }

    
    var body: some View {

            VStack(alignment: .leading, spacing: 10) {
                
                Text("Average: \(Int(healthKitVM.averageStepCount)) steps")
                    .font(.headline)

                Chart {
                    ForEach(healthKitVM.stepData, id: \.date) {
                        step in

                        BarMark(x: .value("day", step.date, unit: .day),
                                y: .value("steps", step.value)
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
//                .chartYAxis {
//                    AxisMarks { value in
//                        AxisValueLabel((value.as(Double.self) ?? 0).formatted(.numb))
//                        
//                    }
//                }
            }
            .padding(.horizontal)
            .navigationTitle("Steps")
            
        List{
            ForEach(steps) {
                step in
                
                DataListView(imageText: "figure.walk",
                             imageColor: .cyan,
                             valueText: step.value,
                             unitText: "steps",
                             date: step.date)
            }
        }
        .listStyle(.inset)
    }
}

struct OneWeekChartView_Previews: PreviewProvider {
    static var previews: some View {
        OneWeekStepChartView()
            .environment(HealthKitViewModel())
    }
}
