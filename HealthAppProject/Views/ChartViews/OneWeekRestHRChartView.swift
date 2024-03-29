//
//  OneWeekRestHRChartView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/13/23.
//
import Charts
import SwiftUI

struct OneWeekRestHRChartView: View {
    @EnvironmentObject var healthStoreVM: HealthStoreViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
      
            Text("Average: \(healthStoreVM.averageRestHR) bpm")
                .font(.headline)
            
            Chart {
                ForEach(healthStoreVM.restingHR.reversed(), id: \.date) {
                    restHrData in
                    
                    LineMark(x: .value("day", restHrData.date, unit: .day),
                             y: .value("RHR", restHrData.restingValue)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(.red)
                    .symbol() {
                        Circle()
                            .fill(.red)
                            .frame(width: 15)
                    }
                }
            }
            .frame(height: 200)
            .chartYScale(domain: 30...80)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) {
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.day().month(), centered: true)
                    
                }
            }
        }
        .padding(.horizontal)
        .navigationTitle("Resting Heart Rate")

        
        List{
            ForEach(healthStoreVM.restingHR.reversed(), id: \.date) {
                restHR in
                
                DataListView(imageText: "heart.fill",
                             imageColor: .red,
                             valueText: "\(restHR.restingValue) bpm",
                             date: restHR.date)
            }
        }
        .listStyle(.inset)
    }
}

struct OneWeekRestHRChartView_Previews: PreviewProvider {
    static var previews: some View {
        OneWeekRestHRChartView()
            .environmentObject(HealthStoreViewModel())
    }
}
