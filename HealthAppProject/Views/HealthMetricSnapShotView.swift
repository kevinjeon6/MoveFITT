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
            VStack(alignment: .leading) {
                NavigationLink {
                    //Go to charts of the HealthMetric
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Heart Overview")
                                .font(.title3)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                .foregroundStyle(.secondary)
                Divider()
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "arrow.down.heart.fill")
                                Text("RHR")
                                    .font(.subheadline)
                                    .fontWeight(.heavy)
                            }
                            Text("62 bpm")
                        }
                        .font(.title2)
                        .padding(.bottom, 20)
                        
                        
                        
                        
                        VStack(alignment: .leading, spacing: 10) {
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
                    .font(.callout)

                    Spacer()
                    
                    
                    VStack(alignment: .leading, spacing: 5) {
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "waveform.path.ecg.rectangle.fill")
                                Text("HRV")
                                    .font(.subheadline)
                                    .fontWeight(.heavy)
                            }
                            Text("220 ms")
                        }
                        .font(.title2)
                        .padding(.bottom, 20)
                        
                        
                        
                        VStack(alignment: .leading, spacing: 10) {
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
                    .font(.callout)
                    Spacer()
                }
                .padding(.top, 15)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 230)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color(.secondarySystemBackground))
            )
        }
    }
}

#Preview {
    HealthMetricSnapShotView()
}
