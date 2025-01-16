//
//  OneWeekKCalBurnedChartView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/30/23.
//
import Charts
import SwiftUI

struct OneWeekKCalBurnedChartView: View {
    
    @Environment(HealthKitViewModel.self) var healthKitVM
    @State private var rawSelectedDate: Date?
    
    private var kcalsBurned: [HealthMetric] {
        healthKitVM.kcalBurnedData.sorted { lhs, rhs in
            lhs.date > rhs.date
        }
    }
    
    var selectedHealthValue: HealthMetric? {
        guard let rawSelectedDate else { return nil }
        return healthKitVM.kcalBurnedData.first { Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date) }
    }

    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            Text(Constants.past7DaysRange)
                .foregroundStyle(.secondary)
            Text("Total: \(Int(healthKitVM.total7DayKcalBurned)) kcal")
            Text("Average: \(Int(healthKitVM.averageKcalBurned)) kcal")
             
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
                
                ForEach(kcalsBurned, id: \.date) {
                    kcal in

                    BarMark(x: .value("day", kcal.date, unit: .day),
                            y: .value("kcal", kcal.value)
                    )
                    .foregroundStyle(.orange.gradient)
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
        .navigationTitle("Kcals Burned")
        .navigationBarTitleDisplayMode(.inline)

        List {
            ForEach(kcalsBurned, id: \.date) {
                burn in
                
                DataListView(imageText: "flame.fill",
                             imageColor: .orange,
                             valueText: burn.value,
                             unitText: "kcal",
                             date: burn.date)
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
            
            Text("\(selectedHealthValue?.value ?? 0, format: .number.precision(.fractionLength(0))) kcal")
                .fontWeight(.semibold)
                .foregroundStyle(.orange)
        }
        .padding(12)
        .background(
            RoundedRectangle( cornerRadius: 4)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .secondary.opacity(0.3), radius: 2, x: 2, y: 2)
        )
    }
}

struct CaloriesBurnedChartView_Previews: PreviewProvider {
    static var previews: some View {
        OneWeekKCalBurnedChartView()
            .environment(HealthKitViewModel())
    }
}
