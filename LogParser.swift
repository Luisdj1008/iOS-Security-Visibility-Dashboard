//
//  LogParser.swift
//  iOS Security Visibility Dashboard
//

import Foundation

func analyzeLog(text: String) -> SecurityReport {
    
    let log = text.lowercased()
    
    var crashCount = 0
    var memoryPressureCount = 0
    var panicCount = 0
    var jailbreakIndicators = 0
    var watchdogCount = 0
    var resourceIssueCount = 0
    
    var findings: [Finding] = []
    var recommendations: [String] = []
    
    let procName = getValue(from: text, key: "procName")
    let bundleID = getValue(from: text, key: "CFBundleIdentifier")
    let signal = getValue(from: text, key: "signal")
    let panicString = getValue(from: text, key: "panicString")
    let modelCode = getValue(from: text, key: "modelCode")
    let osVersion = getValue(from: text, key: "train")
    let reason = getValue(from: text, key: "reason")
    let resourceType = getValue(from: text, key: "resourceType")
    let limit = getValue(from: text, key: "limit")
    
    // 1. Panic check
    if log.contains("panic-full") || log.contains("panicstring") || log.contains("kernel panic") {
        
        panicCount = 1
        
        findings.append(
            Finding(
                title: "System panic or iPhone restart detected",
                explanation: "The log appears to show a serious system-level crash. What this means, the iPhone may have restarted because your software or the hardware encountered a major problem.\n\nModel: \(modelCode)\nOS Version: \(osVersion)\nPanic Details: \(panicString)",
                severity: "High",
                recommendation: "Update iOS. If this panic log keeps appearing, back up the iPhone and contact Apple Supportfor further help."
            )
        )
        
        recommendations.append("Update iOS and monitor for repeated panic logs.")
    }
    
    // 2. Jetsam / memory check
    else if log.contains("jetsamevent") || log.contains("memorystatus") || log.contains("jettisoned") {
        
        memoryPressureCount = 1
        
        findings.append(
            Finding(
                title: "Memory jetsam event detected",
                explanation: "The log shows that iOS may have closed an app to free memory. In simple terms, the iPhone was trying to keep itself working by stopping an app that was using too much memory.",
                severity: "Warning",
                recommendation: "Close unused apps, restart the iPhone, and free up storage space."
            )
        )
        
        recommendations.append("Free up storage space and close unused apps.")
    }
    
    // 3. Watchdog check
    else if log.contains("watchdog") || log.contains("0x8badf00d") {
        
        watchdogCount = 1
        
        findings.append(
            Finding(
                title: "Watchdog freeze or timeout detected",
                explanation: "The log suggests that an app may have frozen or failed to respond quickly enough. In simple terms, iOS stopped the app because it was taking too long to respond.\n\nApp: \(procName)\nReason: \(reason)\nSignal: \(signal)",
                severity: "Warning",
                recommendation: "Update the app, restart the iPhone, and reinstall the app if the freezing continues."
            )
        )
        
        recommendations.append("Update or reinstall the app that froze.")
    }
    
    // 4. Resource overuse check
    else if log.contains("excresource") || log.contains("resource_type") || log.contains("wakeups") {
        
        resourceIssueCount = 1
        
        findings.append(
            Finding(
                title: "Resource overuse detected",
                explanation: "The log suggests that an app used too much of a system resource, such as CPU activity or background wakeups. In simple terms, the app may have been working too hard in the background.\n\nApp: \(procName)\nResource Type: \(resourceType)\nLimit: \(limit)",
                severity: "Warning",
                recommendation: "Update the app, restart the iPhone, and check battery usage if the issue continues."
            )
        )
        
        recommendations.append("Check battery usage and update apps using too many resources.")
    }
    
    // 5. App crash check
    else if log.contains("exception") && log.contains("procname") {
        
        crashCount = 1
        
        findings.append(
            Finding(
                title: "App crash detected",
                explanation: "The log shows that an app crashed or was stopped by iOS. In simple terms, the app did not close normally.\n\nApp: \(procName)\nBundle ID: \(bundleID)\nSignal: \(signal)",
                severity: "Warning",
                recommendation: "Update the app, restart the iPhone, or reinstall the app if the crash happens again."
            )
        )
        
        recommendations.append("Update or reinstall the app that crashed.")
    }
    
    // No major issue found
    else {
        
        findings.append(
            Finding(
                title: "No major warning indicators found",
                explanation: "The log did not clearly match a panic, jetsam event, watchdog timeout, resource overuse issue, or app crash.",
                severity: "Normal",
                recommendation: "No immediate action is needed. Keep iOS and apps updated."
            )
        )
        
        recommendations.append("Keep iOS updated.")
    }
    
    var risk = "Low"
    
    if panicCount > 0 {
        risk = "High"
    } else if crashCount > 0 || memoryPressureCount > 0 || watchdogCount > 0 || resourceIssueCount > 0 {
        risk = "Moderate"
    }
    
    return SecurityReport(
        overallRisk: risk,
        crashCount: crashCount,
        memoryPressureCount: memoryPressureCount,
        panicCount: panicCount,
        jailbreakIndicators: jailbreakIndicators,
        watchdogCount: watchdogCount,
        resourceIssueCount: resourceIssueCount,
        findings: findings,
        recommendations: recommendations
    )
}

func getValue(from text: String, key: String) -> String {
    
    let searchKey = "\"\(key)\""
    
    if let keyRange = text.range(of: searchKey) {
        
        let textAfterKey = text[keyRange.upperBound...]
        
        if let colonRange = textAfterKey.range(of: ":") {
            
            let textAfterColon = textAfterKey[colonRange.upperBound...]
            let cleanedText = textAfterColon.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if cleanedText.first == "\"" {
                
                let textWithoutFirstQuote = cleanedText.dropFirst()
                
                if let endQuote = textWithoutFirstQuote.firstIndex(of: "\"") {
                    return String(textWithoutFirstQuote[..<endQuote])
                }
            } else {
                
                let endIndex = cleanedText.firstIndex(where: { character in
                    character == "," || character == "}" || character == "\n"
                }) ?? cleanedText.endIndex
                
                return String(cleanedText[..<endIndex])
            }
        }
    }
    
    return "Not listed"
}
