//
//  RespiratoryMetricChartView.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 11/30/24.
//

import SwiftUI

struct RespiratoryMetricChartView: View {
    
    @Environment(HealthKitViewModel.self) var healthKitVM
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(Constants.past7DaysRange)
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.gray)
                        .padding()
                    
                    RespiratoryDataChartView(metricTitle: "Blood Oxygen", yValueTitle: "%", unitName: "%", isPercent: true, metricData: healthKitVM.oxygenSaturationData)
                    
                    RespiratoryDataChartView(metricTitle: "Respiratory Rate", yValueTitle: "BrPM", unitName: "breaths/min", isPercent: false, metricData: healthKitVM.respiratoryRateData)

                }
            }
            .background(Color.black)
            .navigationTitle("Respiratory Vitals")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }}

#Preview {
    RespiratoryMetricChartView()
        .environment(HealthKitViewModel())
}
