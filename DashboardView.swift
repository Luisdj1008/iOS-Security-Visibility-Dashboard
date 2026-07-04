//
//  DashboardView.swift
//  iOS Security Visibility Dashboard
//
//  Created by MacBook on 6/16/26.
//

import SwiftUI

struct DashboardView: View {
    let report: SecurityReport

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                Text("Device Security Report")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Overall Risk: \(report.overallRisk)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(riskColor(report.overallRisk))
                    .foregroundColor(.white)
                    .cornerRadius(10)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Log Summary")
                        .font(.headline)

                    Text("Crashes: \(report.crashCount)")
                    Text("Memory Pressure Events: \(report.memoryPressureCount)")
                    Text("Panic Logs: \(report.panicCount)")
                    Text("Jailbreak Indicators: \(report.jailbreakIndicators)")
                    Text("Watchdog Events: \(report.watchdogCount)")
                    Text("Resource Overuse Events: \(report.resourceIssueCount)")
                    
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(10)

                Text("Findings")
                    .font(.headline)

                ForEach(report.findings) { finding in
                    NavigationLink(destination: FindingDetailView(finding: finding)) {
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(finding.title)
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                Text(finding.severity)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(severityColor(finding.severity).opacity(0.2))
                                    .foregroundColor(severityColor(finding.severity))
                                    .cornerRadius(8)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.12))
                        .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                Text("Recommendations")
                    .font(.headline)

                ForEach(report.recommendations, id: \.self) { recommendation in
                    Text("• \(recommendation)")
                        .padding(.bottom, 4)
                }
            }
            .padding()
        }
        .navigationTitle("Dashboard")
    }

    func riskColor(_ risk: String) -> Color {
        if risk == "Low" {
            return Color.green
        } else if risk == "Moderate" {
            return Color.orange
        } else {
            return Color.red
        }
    }

    func severityColor(_ severity: String) -> Color {
        if severity == "High" {
            return Color.red
        } else if severity == "Warning" {
            return Color.orange
        } else {
            return Color.green
        }
    }
}
