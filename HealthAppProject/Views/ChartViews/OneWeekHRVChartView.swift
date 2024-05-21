//
//  OneWeekHRVChartView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 3/3/23.
//

import Charts
import SwiftUI

struct OneWeekHRVChartView: View {
    
    @Environment(HealthKitViewModel.self) var healthKitVM
    
    private var hrv: [HealthMetricValue] {
        healthKitVM.hrvHRData.sorted { lhs, rhs in
            lhs.date > rhs.date
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
    
            
            Chart {
                ForEach(hrv, id: \.date) {
                    hrvData in
                    
                    LineMark(x: .value("day", hrvData.date, unit: .day),
                             y: .value("HRV", hrvData.value)
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
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) {
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.day().month(), centered: true)
                    
                }
            }
        }
        .padding(.horizontal)
        .navigationTitle("Heart Rate Variability")

        
        List{
            ForEach(hrv, id: \.date) {
                hrvHR in
                
                DataListView(imageText: "waveform.path.ecg",
                             imageColor: .red,
                             valueText: hrvHR.value,
                             unitText: "ms",
                             date: hrvHR.date)
            }
        }
        .listStyle(.inset)
    }
}

struct OneWeekHRVChartView_Previews: PreviewProvider {
    static var previews: some View {
        OneWeekHRVChartView()
    }
}
