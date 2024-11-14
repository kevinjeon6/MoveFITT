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
                VStack {
                    
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
                    
                        //TODO: Fix when creating separate views
               
                        QuickOverviewView()
                        
                  
                    
                    // MARK: - Health
                 
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<3) { _ in
                                HealthMetricSnapShotView()
                                
                                
                            }
                        }
                    }
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
