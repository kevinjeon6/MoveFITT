//
//  DashboardScreen.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 11/7/24.
//

import SwiftUI

struct DashboardScreen: View {
    
    @Environment(HealthKitViewModel.self) var healthKitVM
    @EnvironmentObject var settingsVM: SettingsViewModel
    
    // MARK: - Calendar Properties
    @State private var today = Date()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1

    
    let heartGradient = LinearGradient(
        gradient: Gradient(
            colors: [.lightestRed, .lightRed, .mediumRed, .deepRed, .darkRed]
        ),
        startPoint: .top,
        endPoint: .bottom
    )
    
    let respiratoryGradient = LinearGradient(
        gradient: Gradient(
            colors: [.lightestBlue, .lightBlue, .mediumBlue, .deepBlue, .darkBlue]
        ),
        startPoint: .top,
        endPoint: .bottom
    )
    
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
                .padding(.horizontal, 4)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 90)

                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    // MARK: - Overview
                    QuickOverviewView()
                        .padding(.vertical, 20)
                    
                    // MARK: - Health
                    
                    NavigationLink {
                        HeartMetricChartView()
                    } label: {
                        HealthTileInfoView(
                            headerTitleText: "Heart Overview",
                            textGradient: heartGradient,
                            borderColor: .red,
                            imageText1: "arrow.down.heart.fill",
                            metricTitle1: "Resting Heart Rate",
                            metricValue1: healthKitVM.currentRestHR,
                            unit1: "bpm",
                            imageText2: "heart.circle",
                            metricTitle2: "Heart Rate",
                            metricValue2: healthKitVM.currentHR,
                            unit2: "bpm",
                            imageText3: "waveform.path.ecg.rectangle.fill",
                            metricTitle3: "Heart Rate Variability (HRV)",
                            metricValue3: healthKitVM.currentHRV,
                            unit3: "ms"
                        )
                    }

                    NavigationLink {
                        RespiratoryMetricChartView()
                    } label: {
                        HealthTileInfoView(
                            headerTitleText: "Respiratory Overview",
                            textGradient: respiratoryGradient,
                            borderColor: .blue,
                            imageText1: "lungs.fill",
                            metricTitle1: "Respiratory Rate",
                            metricValue1: healthKitVM.currentRespiratoryRate,
                            unit1: "breaths/min",
                            imageText2: "drop.circle",
                            metricTitle2: "Blood Oxygen",
                            metricValue2: healthKitVM.currentSpO2 * 100,
                            unit2: "%",
                            imageText3: "figure.run.circle",
                            metricTitle3: "VO2max",
                            metricValue3: healthKitVM.currentVO2max,
                            unit3: "ml/kg/min"
                        )
                    }

                    Spacer()
                }
            }
            .background(Color.primary)
            .task {
                await healthKitVM.displayData()
            }
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
        .environmentObject(SettingsViewModel())
}


