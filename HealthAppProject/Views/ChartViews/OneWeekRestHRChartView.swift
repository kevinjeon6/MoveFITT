//
//  OneWeekRestHRChartView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/13/23.
//
import Charts
import HealthKit
import SwiftUI

struct OneWeekRestHRChartView: View {
    @EnvironmentObject var healthStoreVM: HealthStoreViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
      
            Text("Average: \(healthStoreVM.restingHR.reduce(0) { $0 + $1.restingValue / 7}) bpm")
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
        
        List{
            ForEach(healthStoreVM.restingHR.reversed(), id: \.date) {
                restHR in
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                        Text("\(restHR.restingValue) bpm")
                            .font(.title2)
                            .bold()
                    }
                    Text(restHR.date, style: .date)
                        .opacity(0.5)
                }
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
