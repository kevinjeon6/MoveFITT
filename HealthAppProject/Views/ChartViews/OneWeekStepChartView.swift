//
//  OneWeekChartView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/13/23.
//

import Charts
import SwiftUI

struct OneWeekStepChartView: View {
//  @EnvironmentObject var healthStoreVM: HealthStoreViewModel
    @Environment(HealthKitViewModel.self) var healthKitVM

    
    var body: some View {

            VStack(alignment: .leading, spacing: 10) {
                //reduce adds up the total count
//                Text("Average: \(healthStoreVM.averageStepCount) steps")
//                    .font(.headline)

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
            }
            .padding(.horizontal)
            .navigationTitle("Steps")
            
        List{
            ForEach(healthKitVM.stepData.reversed(), id: \.date) {
                step in
                
                DataListView(imageText: "figure.walk",
                             imageColor: .cyan,
                             valueText: "\(step.value) steps",
                             date: step.date)
            }
        }
        .listStyle(.inset)
        
    }
}

struct OneWeekChartView_Previews: PreviewProvider {
    static var previews: some View {
        OneWeekStepChartView()
//            .environmentObject(HealthStoreViewModel())
            .environment(HealthKitViewModel())
    }
}
