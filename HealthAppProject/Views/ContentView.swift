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
      NavigationView {
            VStack {
                Text("\(healthStore.currentStepCount)")
                List(healthStore.steps.reversed(), id: \.id) {
                    item in
               
                    VStack {
                        Text("\(item.count) steps")
                        Text("\(item.date, style: .date)")
                    }
                }
            }
            .navigationTitle("Health Project App")
       
        }
        .onAppear {
            healthStore.requestUserAuthorization { success in
                if success {
                    healthStore.calculateDataForOneWeek { statisticscollection in
                        if let statisticscollection = statisticscollection {
                            healthStore.updateUIFromStatistics(statisticscollection)
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
