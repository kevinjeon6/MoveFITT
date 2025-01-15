//
//  HeartMetricChartView.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 11/30/24.
//

import SwiftUI

struct HeartMetricChartView: View {
    
    @Environment(HealthKitViewModel.self) var healthKitVM
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(Constants.past7DaysRange)
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.gray)
                        .padding()
                    
                    HeartDataChartView(metricTitle: "Resting Heart Rate", yValueTitle: "RHR", unitName: "bpm", metricData: healthKitVM.restingHRData)
                    HeartDataChartView(metricTitle: "Heart Rate Variability", yValueTitle: "ms", unitName: "ms", metricData: healthKitVM.hrvHRData)

                }
            }
            .background(Color.black)
            .navigationTitle("Heart Vitals")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
}

#Preview {
    HeartMetricChartView()
        .environment(HealthKitViewModel())
}
