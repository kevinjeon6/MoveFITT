//
//  OneWeekRestHRChartView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/13/23.
//
import Charts
import SwiftUI

struct OneWeekRestHRChartView: View {

    @Environment(HealthKitViewModel.self) var healthKitVM
    @State private var rawSelectedDate: Date?
    
    private var restingHR: [HealthMetricValue] {
        healthKitVM.restingHRData.sorted { lhs, rhs in
            lhs.date > rhs.date
        }
    }
    
    var selectedHealthValue: HealthMetricValue? {
        guard let rawSelectedDate else { return nil }
        return healthKitVM.restingHRData.first { Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date) }
    }

    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
            Text(Constants.past7DaysRange)
                .foregroundStyle(.secondary)
            
            Text("Average: \(Int(healthKitVM.averageRestHR)) bpm")
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
                
                ForEach(restingHR, id: \.date) {
                    restHrData in
                    
                    LineMark(x: .value("day", restHrData.date, unit: .day),
                             y: .value("RHR", restHrData.value)
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
        .navigationTitle("Resting Heart Rate")
        .navigationBarTitleDisplayMode(.inline)
        
        List{
            ForEach(restingHR, id: \.date) {
                restHR in
                
                DataListView(imageText: "heart.fill",
                             imageColor: .red,
                             valueText: restHR.value,
                             unitText: "bpm",
                             date: restHR.date)
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
            
            Text("\(selectedHealthValue?.value ?? 0, format: .number.precision(.fractionLength(0))) bpm")
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

struct OneWeekRestHRChartView_Previews: PreviewProvider {
    static var previews: some View {
        OneWeekRestHRChartView()
            .environment(HealthKitViewModel())
    }
}
