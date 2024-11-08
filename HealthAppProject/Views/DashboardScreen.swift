//
//  DashboardScreen.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 11/7/24.
//

import SwiftUI

struct DashboardScreen: View {
    
    @Environment(HealthKitViewModel.self) var healthKitVM
    @State private var today = Date()
    
    
    // Generate a range of dates from past to future
    private var dateRange: [Date] {
        let calendar = Calendar.current
        let today = Date()
        
        // Define the range: 14 days before and after today
        return (-14...14).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: today)
        }
    }
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.primary.ignoresSafeArea(.all)
                ScrollView {
                    
                    // MARK: - Header
                    ///Make a separate view?
                    VStack(alignment: .leading) {
                        Text("\(Constants.todayDateString)")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.gray)
                        
                        Text("Dashboard")
                            .font(.title.bold())
                            .foregroundStyle(.white)
                            
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 8)
                    
                    
                    // MARK: - Calendar
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(dateRange, id: \.self) { date in
                                VStack {
                                    Text(dateFormatted(date: date, format: "d"))
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    
                                    Text(dateFormatted(date: date, format: "E"))
                                        .font(.subheadline)
                                        .foregroundStyle(.white)
                                }
                                .frame(width: 50, height: 70)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Calendar.current.isDate(date, inSameDayAs: today) ? Color.cyan : Color.clear, lineWidth: 4)
                                }
                            }
                        }
                    }
                    
                    // MARK: - Overview
  
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Daily Overview")
                            
                            HStack {
                                Image(systemName: "stopwatch")
                                    .foregroundStyle(.green)
                                Text("\(healthKitVM.mostRecentExerciseTime) / 0 mins")
                            }
                            
                            HStack {
                                Image(systemName: "figure.walk")
                                    .foregroundStyle(.cyan)
                                Text("\(healthKitVM.currentStepCount) / 10,000 steps")
                            }
                            HStack {
                                Image(systemName: "flame.fill")
                                    .foregroundStyle(.orange)
                                Text("\(healthKitVM.currentKcalsBurned) / kcals ")
                            }
                        }
                        //                    .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(width: 180, height: 185)
                        .foregroundStyle(.white)
//                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(#colorLiteral(red: 0.1353680193, green: 0.1355423033, blue: 0.1408430636, alpha: 1)))
                            
                        )
                        
                        VStack(alignment: .leading) {
                            Text("Strength Training")
                                .foregroundStyle(.white)
                                .padding()
                            HStack {
                                Text("Goal: 0/2")
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            }
                            
                            ProgressGaugeView(progress: 1.0, minValue: 0.0, maxValue: 2.0, scaleValue: 1.0, gaugeColor: .green, title: 2)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .frame(width: 180, height: 185)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(#colorLiteral(red: 0.1353680193, green: 0.1355423033, blue: 0.1408430636, alpha: 1)))
                            
                        )
                    }
                    .padding()
                    
                    // MARK: - Health
                    VStack(alignment: .leading) {
                        Text("Strength Training")
                            .foregroundStyle(.white)
                            .padding()
                        HStack {
                            Text("Goal: 0/2")
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                        
                        ProgressGaugeView(progress: 1.0, minValue: 0.0, maxValue: 2.0, scaleValue: 1.0, gaugeColor: .green, title: 2)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 250)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(#colorLiteral(red: 0.1353680193, green: 0.1355423033, blue: 0.1408430636, alpha: 1)))
                        
                    )
                    .padding()
                }
            }

        }
    }
    
    // Helper function to format the date
    private func dateFormatted(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

#Preview {
    DashboardScreen()
        .environment(HealthKitViewModel())
}
