//
//  QuickOverviewView.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 11/14/24.
//

import SwiftUI

struct QuickOverviewView: View {
    
    @State private var currentCard: Int? = 0

    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    DailyOverviewView()
                        .containerRelativeFrame(.horizontal)
                        .id(0)

                    
                    WeeklyOverviewView()
                        .containerRelativeFrame(.horizontal)
                        .id(1)
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $currentCard)


            
            // MARK: - Indicators
            IndicatorView(currentCard: $currentCard)
                .padding(.top, 5)
        } 
    }
}




#Preview {
    QuickOverviewView()
        .environment(HealthKitViewModel())
        .environmentObject(SettingsViewModel())
}
