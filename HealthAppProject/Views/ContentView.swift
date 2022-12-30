//
//  ContentView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 12/27/22.
//

import HealthKit
import SwiftUI

struct ContentView: View {
  
    @StateObject var healthStore = HealthStoreViewModel()

    
    var body: some View {
        ScrollView {
            VStack {
                Text("\(healthStore.currentStepCount)")
                List(healthStore.steps, id: \.id) {
                    item in
                    Text("\(item.count)")
                    Text("\(item.date)")
                }
            }
        }
        .onAppear {
            healthStore.requestUserAuthorization { success in
                if success {
                    healthStore.calculateDataForOneWeek { statisticsCollection in
                        if let statisticsCollection = statisticsCollection {
                            healthStore.updateUIFromStatistics(statisticsCollection)
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
