//
//  OneWeekExerciseTimeChartView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/16/23.
//

import Charts
import SwiftUI

struct OneWeekExerciseTimeChartView: View {
    
    var healthKitVM: HealthKitViewModel
    @State private var rawSelectedDate: Date?
    @State private var isShowingList = false
    
    private var chartTime: [HealthMetricValue] {
        healthKitVM.exerciseTimeData.sorted { lhs, rhs in
            lhs.date > rhs.date
        }
    }
    
    var selectedHealthValue: HealthMetricValue? {
        guard let rawSelectedDate else { return nil }
        return healthKitVM.exerciseTimeData.first { Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            Text("Average: \(Int(healthKitVM.chartAverageExTime)) min")
                .font(.headline)
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
                
                ForEach(chartTime, id: \.date) {
                    time in
                    
                    BarMark(x: .value("day", time.date, unit: .day),
                             y: .value("ex time", time.value)
                    )
                    .foregroundStyle(.green.gradient)
                    .cornerRadius(5)
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
        
        VStack {
            Toggle("Show List", isOn: $isShowingList)
                .padding(.horizontal)
            
            Divider()
            
            if isShowingList {
                List{
                    ForEach(chartTime, id: \.date) { exTime in
                        DataListView(imageText: "figure.mixed.cardio",
                                     imageColor: .green,
                                     valueText: exTime.value,
                                     unitText: "min",
                                     date: exTime.date)
                    }
                }
                .listStyle(.inset)
            }
        }
        Spacer()
        
    }
    
    // MARK: - Annotation View

    var annotationView: some View {
        VStack(alignment: .leading) {
            Text(selectedHealthValue?.date ?? .now, format: .dateTime.weekday(.abbreviated).month(.abbreviated).day())
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
            
            Text("\(selectedHealthValue?.value ?? 0, format: .number.precision(.fractionLength(0))) min")
                .fontWeight(.semibold)
                .foregroundStyle(.green)
        }
        .padding(12)
        .background(
            RoundedRectangle( cornerRadius: 4)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .secondary.opacity(0.3), radius: 2, x: 2, y: 2)
        )
    }
}


struct OneWeekExerciseTimeChartView_Previews: PreviewProvider {
    static var previews: some View {
       OneWeekExerciseTimeChartView(healthKitVM: HealthKitViewModel())
    }
}
