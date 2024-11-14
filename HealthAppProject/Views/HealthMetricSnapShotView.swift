//
//  HealthMetricSnapShotView.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 11/11/24.
//

import SwiftUI

struct HealthMetricSnapShotView: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    //Go to charts of the HealthMetric
                } label: {
                    HStack {
                            Text("Heart Overview")
                                .font(.title3)
                        
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding(.bottom, 4)
                }
                .foregroundStyle(.secondary)

                Divider()

                Grid(alignment: .leading, horizontalSpacing: 80, verticalSpacing: 20) {
                    GridRow {
                        // MARK: - Make into a reusable view
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Image(systemName: "arrow.down.heart.fill")
                                Text("RHR")
                                    .font(.subheadline)
                                    .fontWeight(.heavy)
                            }
                            Text("62 bpm")
                        }
                        .font(.title2)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Image(systemName: "heart.circle.fill")
                                Text("HR")
                                    .font(.subheadline)
                                    .fontWeight(.heavy)
                                
                            }
                            Text("74 bpm")
                        }
                        .font(.title2)

                    }
                    
                    GridRow {
                        // MARK: - Make into a reusable view
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Image(systemName: "waveform.path.ecg.rectangle.fill")
                                Text("HRV")
                                    .font(.subheadline)
                                    .fontWeight(.heavy)
                            }
                            Text("220 ms")
                        }
                        .font(.title2)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Image(systemName: "heart.circle.fill")
                                Text("Walking HR")
                                    .font(.subheadline)
                                    .fontWeight(.heavy)
                            }
                            
                            Text("76 bpm")
                            
                        }
                        .font(.title2)
                    }
                }
                .padding(.top, 20)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color(.secondarySystemBackground))
            )
        }
    }
}

#Preview {
    HealthMetricSnapShotView()
}
