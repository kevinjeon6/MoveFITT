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
                    
           
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Daily Overview")
                                .foregroundStyle(.white)
                                .font(.title2.weight(.semibold))
                                .padding([.leading, .bottom])
                                .padding(.top, 10)
                             
                            HStack {
                                Image(systemName: "figure.walk")
                                    .foregroundStyle(.cyan)
                                Text("\(healthKitVM.currentStepCount) / 10,000 steps")
                                    .foregroundStyle(.white)
                            }
                            .padding(.leading)
                            HStack {
                                ProgressionStepBar(value: 5000, goalValue: 10_000)
                                Text("50%")
                                    .layoutPriority(1)
                                    .foregroundStyle(.white)
                            }
                            
                            
                            
                            HStack {
                                Image(systemName: "stopwatch")
                                    .foregroundStyle(.green)
                                Text("\(healthKitVM.mostRecentExerciseTime) / 0 mins")
                                    .foregroundStyle(.white)
                            }
                            .padding(.leading)
                            HStack {
                                ProgressionStepBar(value: 5000, goalValue: 10_000)
                                Text("50%")
                                    .layoutPriority(1)
                                    .foregroundStyle(.white)
                            }
                            
                            HStack {
                                Image(systemName: "flame.fill")
                                    .foregroundStyle(.orange)
                                Text("\(healthKitVM.currentKcalsBurned) / kcals ")
                                    .foregroundStyle(.white)
                            }
                            .padding(.leading)
                            HStack {
                                ProgressionStepBar(value: 5000, goalValue: 10_000)
                                Text("50%")
                                    .layoutPriority(1)
                                    .foregroundStyle(.white)
                            }
                        }
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 210)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color(#colorLiteral(red: 0.1353680193, green: 0.1355423033, blue: 0.1408430636, alpha: 1)))
                            
                        )
                        .padding()
                    
                    // MARK: - Health
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Weekly Overview")
                            .foregroundStyle(.white)
                            .font(.title2.weight(.semibold))
                            .padding([.leading, .bottom])
                            .padding(.top, 10)
                        
                        Text("Strength Traning")
                        HStack {
                            Text("Goal: 0/2")
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                        .padding(.bottom)
                        
                        Text("Physical Activity")
                        HStack {
                            Text("200/350")
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 210)
                    .foregroundStyle(.white)
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
