//
//  ImportLogView.swift
//  iOS Security Visibility Dashboard
//

import SwiftUI

struct ImportLogView: View {
    @State private var logText = ""
    @State private var report = sampleReport
    @State private var goToDashboard = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            Text("Import Diagnostic Log")
                .font(.title)
                .fontWeight(.bold)

            Text("Paste diagnostic log text below. The app will check for crashes, memory pressure, panic logs, and jailbreak indicators.")
                .foregroundColor(.gray)

            TextEditor(text: $logText)
                .frame(height: 250)
                .padding(8)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(10)

            Button(action: {
                logText = sampleLogText
            }) {
                Text("Load Sample Log Text")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.25))
                    .foregroundColor(.primary)
                    .cornerRadius(10)
            }

            Button(action: {
                report = analyzeLog(text: logText)
                goToDashboard = true
            }) {
                Text("Analyze Log")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            NavigationLink(
                destination: DashboardView(report: report),
                isActive: $goToDashboard
            ) {
                EmptyView()
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Import Log")
    }
}

let sampleLogText = """
{
  "bug_type": "298",
  "incident": "JET-SAMPLE-12345",
  "timestamp": "2026-06-24 12:45:22 -0700",
  "modelCode": "iPhone13,3",
  "osVersion": {
    "train": "iPhone OS 18.5",
    "build": "22F76"
  },

  "logType": "JetsamEvent",
  "memorystatus": "jettisoned",
  "reason": "highwater",

  "largestProcess": "Instagram",
  "processes": [
    {
      "procName": "Instagram",
      "pid": 1001,
      "reason": "jettisoned",
      "memoryStatus": "high memory usage"
    },
    {
      "procName": "Safari",
      "pid": 442,
      "reason": "active",
      "memoryStatus": "normal"
    },
    {
      "procName": "Photos",
      "pid": 733,
      "reason": "background",
      "memoryStatus": "normal"
    }
  ]
}
"""
