//
//  SecurityReport.swift
//  iOS Security Visibility Dashboard
//

import Foundation

struct Finding: Identifiable {
    let id = UUID()
    let title: String
    let explanation: String
    let severity: String
    let recommendation: String
}

struct SecurityReport {
    let overallRisk: String
    let crashCount: Int
    let memoryPressureCount: Int
    let panicCount: Int
    let jailbreakIndicators: Int
    let watchdogCount: Int
    let resourceIssueCount: Int
    let findings: [Finding]
    let recommendations: [String]
}

let sampleReport = SecurityReport(
    overallRisk: "Moderate",
    crashCount: 17,
    memoryPressureCount: 3,
    panicCount: 0,
    jailbreakIndicators: 0,
    watchdogCount: 0,
    resourceIssueCount: 0,
    findings: [
        Finding(
            title: "Instagram crashed 17 times",
            explanation: "Instagram crashed repeatedly in the diagnostic logs. This usually means the app may be outdated, unstable, or having trouble running on the device.",
            severity: "Warning",
            recommendation: "Update Instagram from the App Store. If the crashes continue, restart the iPhone or reinstall Instagram."
        ),
        Finding(
            title: "Memory pressure events detected",
            explanation: "The device reported memory pressure events. This means iOS may have been low on available memory and may have closed apps to keep the system running.",
            severity: "Warning",
            recommendation: "Close unused apps, restart the iPhone, and free up storage space."
        ),
        Finding(
            title: "No jailbreak indicators found",
            explanation: "The diagnostic log did not show common signs associated with a jailbroken device. This is a normal result.",
            severity: "Normal",
            recommendation: "No action is needed. Continue keeping iOS updated."
        )
    ],
    recommendations: [
        "Update or reinstall apps that crash repeatedly.",
        "Restart the device if performance feels slow.",
        "Free up storage space.",
        "Keep iOS updated."
    ]
)
