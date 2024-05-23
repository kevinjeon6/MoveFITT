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
    @State private var rawSelectedDate: Date?
    
    private var hrv: [HealthMetricValue] {
        healthKitVM.hrvHRData.sorted { lhs, rhs in
            lhs.date > rhs.date
        }
    }
    
    var selectedHealthValue: HealthMetricValue? {
        guard let rawSelectedDate else { return nil }
        return healthKitVM.hrvHRData.first { Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(Constants.past7DaysRange)
                .foregroundStyle(.secondary)
            
            Text("Average: \(Int(healthKitVM.averageHRV)) bpm")
                .padding(.bottom, 10)
    
            Chart {
                if let selectedHealthValue {
                    RuleMark(x: .value("Selected Metric", selectedHealthValue.date, unit: .day))
                        .foregroundStyle(Color.secondary.opacity(0.3))
                        .offset(y: -10)
                        .zIndex(-1)
                        .annotation(
                            position: .top,
                            spacing: 0,
                            overflowResolution: .init(
                                x: .fit(to: .chart),
                                y: .disabled
                            )
                        ) {
                            annotationView
                        }
                }
                
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
            .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) {
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.day().month(), centered: true)
                }
            }
        }
        .padding(.horizontal)
        .font(.headline)
        .navigationTitle("Heart Rate Variability")
        .navigationBarTitleDisplayMode(.inline)

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
    
    // MARK: - Annotation View
    
    var annotationView: some View {
        VStack(alignment: .leading) {
            Text(selectedHealthValue?.date ?? .now, format: .dateTime.weekday(.abbreviated).month(.abbreviated).day())
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
            
            Text("\(selectedHealthValue?.value ?? 0, format: .number.precision(.fractionLength(0))) ms")
                .fontWeight(.semibold)
                .foregroundStyle(.red)
        }
        .padding(12)
        .background(
            RoundedRectangle( cornerRadius: 4)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .secondary.opacity(0.3), radius: 2, x: 2, y: 2)
        )
    }
}

struct OneWeekHRVChartView_Previews: PreviewProvider {
    static var previews: some View {
        OneWeekHRVChartView()
            .environment(HealthKitViewModel())
    }
}
