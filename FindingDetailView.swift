//
//  FindingDetailView.swift
//  iOS Security Visibility Dashboard
//
//  Created by MacBook on 6/16/26.
//

import SwiftUI

struct FindingDetailView: View {
    let finding: Finding

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                Text(finding.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Severity: \(finding.severity)")
                    .font(.headline)
                    .foregroundColor(severityColor)

                Text("What this means")
                    .font(.title2)
                    .fontWeight(.bold)

                Text(finding.explanation)
                    .font(.body)

                Text("Recommendation")
                    .font(.title2)
                    .fontWeight(.bold)

                Text(finding.recommendation)
                    .font(.body)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Finding Detail")
    }

    var severityColor: Color {
        if finding.severity == "High" {
            return .red
        } else if finding.severity == "Warning" {
            return .orange
        } else {
            return .green
        }
    }
}
