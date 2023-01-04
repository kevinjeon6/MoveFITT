//
//  ContentView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 12/27/22.
//

import Charts
import HealthKit
import SwiftUI

struct ContentView: View {
  
    @StateObject var healthStore = HealthStoreViewModel()
    
 

    
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
        
      NavigationView {
          VStack(spacing: 10) {
                Text("Step Count")
                //reduce adds up the total count
                Text("Total: \(Step.stepExample.reduce(0, { $0 + $1.count}))")
              Text("Average: \(Step.stepExample.reduce(0, { $0 + $1.count / 7}))")
                
                Chart {
                    ForEach(Step.stepExample) {
                        stepData in
                        
                        LineMark(x: .value("day", stepData.date, unit: .day),
                                y: .value("steps", stepData.count)
                        )
                        .interpolationMethod(.cardinal)
                        .foregroundStyle(.purple)
                        .symbol(Circle())
                        
                        AreaMark(x: .value("day", stepData.date, unit: .day),
                                 y: .value("steps", stepData.count)
                        )
                        .interpolationMethod(.cardinal)
                        .foregroundStyle(curGradient)
                        
                    }
               
                    
                    RuleMark(y: .value("Goal", 10_000))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
//                        .annotation(alignment: .leading) {
//                            Text("Goal")
//                                .font(.caption)
//                                .foregroundColor(.blue)
//                        }
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks(values: Step.stepExample.map{ $0.date}) { date in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.day().month())
                    }
                }
//                .chartPlotStyle { plotContent in
//                    plotContent
//                        .background(.yellow.gradient.opacity(0.4))
//                }

                  HStack {
                        Image(systemName: "line.diagonal")
                            .rotationEffect(Angle(degrees: 45))
                            .foregroundColor(.red)
                        
                        Text("Goal Steps")
                    }
                    .font(.caption2)
                .padding(.leading, 4)
              
                Spacer()
            }
          .padding(.horizontal)
          .navigationTitle("Health Project App")
        }
        .onAppear {
            healthStore.requestUserAuthorization { success in
                if success {
                    healthStore.calculateDataForOneWeek { statisticscollection in
                        if let statisticscollection = statisticscollection {
                            healthStore.updateUIFromStatistics(statisticscollection)
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
