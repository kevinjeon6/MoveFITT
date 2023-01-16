//
//  OneWeekChartView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/13/23.
//

import Charts
import SwiftUI

struct OneWeekStepChartView: View {
  @ObservedObject var healthStoreVM: HealthStoreViewModel

    
    var body: some View {
        let curColor = Color(red: 0.40, green: 0.242, blue: 1.0)
        let curGradient = LinearGradient(
            gradient: Gradient (
                colors: [
                    curColor.opacity(0.5),
                    curColor.opacity(0.2),
                    curColor.opacity(0.05),
                ]
            ),
            startPoint: .top,
            endPoint: .bottom
        )
        
        VStack(alignment: .leading, spacing: 10) {
            //reduce adds up the total count
            Text("Weekly Step Total: \(healthStoreVM.steps.reduce(0, { $0 + $1.count}))")
            Text("Step Count Average: \(healthStoreVM.steps.reduce(0, { $0 + $1.count / 7}))")
            
            Chart {
                ForEach(healthStoreVM.steps, id: \.date) {
                    stepData in
                    
                    LineMark(x: .value("day", stepData.date, unit: .day),
                             y: .value("steps", stepData.count)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(.purple)
                    .symbol(Circle())
                    
                    AreaMark(x: .value("day", stepData.date, unit: .day),
                             y: .value("steps", stepData.count)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(curGradient)
                }
                
                
                RuleMark(y: .value("Goal", 10_000))
                //                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                //                        .annotation(alignment: .leading) {
                //                            Text("Goal")
                //                                .font(.caption)
                //                                .foregroundColor(.blue)
                //                        }
            }
            .frame(height: 200)
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

struct OneWeekChartView_Previews: PreviewProvider {
    static var previews: some View {
        OneWeekStepChartView(healthStoreVM: HealthStoreViewModel())
    }
}
