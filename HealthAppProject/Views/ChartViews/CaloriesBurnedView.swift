//
//  CaloriesBurned.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/30/23.
//
import Charts
import SwiftUI

struct CaloriesBurnedChartView: View {
    
//    @EnvironmentObject var healthStoreVM: HealthStoreViewModel
    @Environment(HealthKitViewModel.self) var healthKitVM
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
//            Text("Average: \(healthStoreVM.averageKcalsBurned) kcal")
//                .font(.headline)

            Chart {
                ForEach(healthKitVM.kcalBurnedData, id: \.date) {
                    kcal in

                    BarMark(x: .value("day", kcal.date, unit: .day),
                            y: .value("kcal", kcal.value)
                    )
                    .foregroundStyle(.orange.gradient)
                    .cornerRadius(5)
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
        .navigationTitle("Kcals Burned")

        
        
        List {
            ForEach(healthKitVM.kcalBurnedData.reversed(), id: \.date) {
                burn in
                
                DataListView(imageText: "flame.fill",
                             imageColor: .orange,
                             valueText: "\(burn.value) kcal",
                             date: burn.date)
            }
        }
        .listStyle(.inset)
    }
}

struct CaloriesBurnedChartView_Previews: PreviewProvider {
    static var previews: some View {
        CaloriesBurnedChartView()
//            .environmentObject(HealthStoreViewModel())
            .environment(HealthKitViewModel())
    }
}
