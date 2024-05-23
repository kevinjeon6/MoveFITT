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
    @State private var rawSelectedDate: Date?
    
    private var steps: [HealthMetricValue] {
        healthKitVM.stepData.sorted { lhs, rhs in
            lhs.date > rhs.date
        }
    }
    
    var selectedHealthValue: HealthMetricValue? {
        guard let rawSelectedDate else { return nil }
        return healthKitVM.stepData.first { Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date) }
    }

    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            Text(Constants.past7DaysRange)
                .foregroundStyle(.secondary)
            Text("Total: \(Int(healthKitVM.total7DayStepCount)) steps")
            Text("Average: \(Int(healthKitVM.averageStepCount)) steps")
        
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
        .navigationTitle("Steps")
        .navigationBarTitleDisplayMode(.inline)
  
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
    
    // MARK: - Annotation View
    
    var annotationView: some View {
        VStack(alignment: .leading) {
            Text(selectedHealthValue?.date ?? .now, format: .dateTime.weekday(.abbreviated).month(.abbreviated).day())
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
            
            Text("\(selectedHealthValue?.value ?? 0, format: .number.precision(.fractionLength(0))) steps")
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

struct OneWeekChartView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            OneWeekStepChartView()
                .environment(HealthKitViewModel())
                .navigationTitle("Steps")
        }
    }
}
