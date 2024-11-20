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
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $currentCard)


            
            // MARK: - Indicators
            IndicatorView(currentCard: $currentCard)
                .padding(.top, 5)
        } 
    }
}


struct IndicatorView: View {
    @Binding var currentCard: Int?

    
    var body: some View {
        HStack {
            ForEach(0..<2) { index in
                    Circle()
                    .fill(currentCard == index ? .white : Color(.lightGray))
                    .frame(width: currentCard == index ? 12 : 8, height: 8)
                    .shadow(radius: 4)
                    .onTapGesture {
                        currentCard = index
                    }
            }
        }
        .padding(5)
        .background(.thickMaterial, in: Capsule())
    }
}

#Preview {
    QuickOverviewView()
}
