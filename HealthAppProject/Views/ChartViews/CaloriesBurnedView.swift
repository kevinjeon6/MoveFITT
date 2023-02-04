//
//  CaloriesBurned.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/30/23.
//
import Charts
import HealthKit
import SwiftUI

struct CaloriesBurnedChartView: View {
    
    @EnvironmentObject var healthStoreVM: HealthStoreViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            Text("Average: \(healthStoreVM.kcalBurned.reduce(0, { $0 + $1.kcal / 7})) kcal")
                .font(.headline)

            Chart {
                ForEach(healthStoreVM.kcalBurned, id: \.date) {
                    kcalData in

                    BarMark(x: .value("day", kcalData.date, unit: .day),
                            y: .value("kcal", kcalData.kcal)
                    )
                    .foregroundStyle(.orange.gradient)
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
        
        
        List {
            ForEach(healthStoreVM.kcalBurned.reversed(), id: \.date) {
                burn in
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        Text("\(burn.kcal) kcal")
                            .font(.title2)
                            .bold()
                    }
                    Text(burn.date, style: .date)
                        .opacity(0.5)
                }
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