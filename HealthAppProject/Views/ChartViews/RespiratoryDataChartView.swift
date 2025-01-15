//
//  RespiratoryDataChartView.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 1/12/25.
//

import Charts
import SwiftUI

struct RespiratoryDataChartView: View {
    
    @State private var rawSelectedDate: Date?
    var metricTitle: String
    var yValueTitle: String
    var unitName: String
    var isPercent: Bool
    var metricData: [HealthMetric]

    var selectedHealthValue: HealthMetric? {
        guard let rawSelectedDate else { return nil }
        return metricData.first { Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date) }
    }

    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
      
            GroupBox(metricTitle) {
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
                    
                    ForEach(metricData, id: \.date) { data in
                        
                        LineMark(x: .value("day", data.date, unit: .day),
                                 y: .value(yValueTitle, isPercent ? (data.value * 100) : data.value)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(.cyan)
                        .symbol() {
                            Circle()
                                .foregroundStyle(.cyan)
                                .frame(width: 8)
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
            
        }
        .padding(.horizontal)
        .font(.headline)
        .environment(\.colorScheme, .dark)
    }
    
    // MARK: - Annotation View
    
    var annotationView: some View {
        VStack(alignment: .leading) {
            Text(selectedHealthValue?.date ?? .now, format: .dateTime.weekday(.abbreviated).month(.abbreviated).day())
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
            
            Text("\(((isPercent ? ((selectedHealthValue?.mostRecentValue ?? 0) * 100) : selectedHealthValue?.mostRecentValue ?? 0)), format: .number.precision(.fractionLength(0))) \(unitName)")
                .fontWeight(.semibold)
                .foregroundStyle(.cyan)
        }
        .padding(12)
        .background(
            RoundedRectangle( cornerRadius: 4)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .secondary.opacity(0.3), radius: 2, x: 2, y: 2)
        )
    }
}

#Preview {
    RespiratoryDataChartView(metricTitle: "Blood Oxygen", yValueTitle: "%", unitName: "$", isPercent: true, metricData: MockData.heartRate)
}
