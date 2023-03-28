//
//  CaloriesBurned.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/30/23.
//
import Charts
import SwiftUI

struct CaloriesBurnedChartView: View {
    
    @EnvironmentObject var healthStoreVM: HealthStoreViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            Text("Average: \(healthStoreVM.averageKcalsBurned) kcal")
                .font(.headline)

            Chart {
                ForEach(healthStoreVM.kcalBurned, id: \.date) {
                    kcalData in

                    BarMark(x: .value("day", kcalData.date, unit: .day),
                            y: .value("kcal", kcalData.kcal)
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
            ForEach(healthStoreVM.kcalBurned.reversed(), id: \.date) {
                burn in
                
                DataListView(imageText: "flame.fill",
                             imageColor: .orange,
                             valueText: "\(burn.kcal) kcal",
                             date: burn.date)
            }
        }
        .listStyle(.inset)
    }
}

struct CaloriesBurnedChartView_Previews: PreviewProvider {
    static var previews: some View {
        CaloriesBurnedChartView()
            .environmentObject(HealthStoreViewModel())
    }
}
