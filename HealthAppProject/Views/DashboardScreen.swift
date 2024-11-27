//
//  DashboardScreen.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 11/7/24.
//

import SwiftUI

struct DashboardScreen: View {
    
    @Environment(HealthKitViewModel.self) var healthKitVM
    
    // MARK: - Calendar Properties
    @State private var today = Date()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1

    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // MARK: - Header
                DashboardHeaderView()
                
                // MARK: - Calendar
                TabView(selection: $currentWeekIndex) {
                    ForEach(weekSlider.indices, id: \.self) { index in
                        let week = weekSlider[index]
                        WeekView(week)
                            .tag(index)
                    }
                }
                .padding(.horizontal, -15)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 90)

                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    // MARK: - Overview
                    QuickOverviewView()
                        .padding(.vertical, 20)
                    
                    // MARK: - Health
                    
                    HeartMetricsView()
                    RespiratoryMetricsView()
                    
                    Spacer()
                }
            }
            .background(Color.primary)
            .onAppear {
                if weekSlider.isEmpty {
                    let currentWeek = Date().fetchWeek()
                    
                    if let firstDate = currentWeek.first?.date {
                        weekSlider.append(firstDate.previousWeek())
                    }
                    
                    weekSlider.append(currentWeek)
                    
                    if let lastDate = currentWeek.last?.date {
                        weekSlider.append(lastDate.nextWeek())
                    }
                }
            }
        }
    }
    

    // MARK: - Weekly View
    @ViewBuilder
    func WeekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) { day in
                VStack(spacing: 4) {
                    Text(day.date.format("d"))
                        .font(.headline)
                        .foregroundStyle(.white)
                      
                    
                    Text(day.date.format("E"))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)

                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Calendar.current.isDate(day.date, inSameDayAs: today) ? Color.cyan : Color.clear, lineWidth: 2)
                }
                .contentShape(.rect)
                .onTapGesture {
                    ///Updating Current Date
                    withAnimation(.snappy) {
                        today = day.date
                    }
                }
            }
        }
    }
    
}

#Preview {
    DashboardScreen()
        .environment(HealthKitViewModel())
}


