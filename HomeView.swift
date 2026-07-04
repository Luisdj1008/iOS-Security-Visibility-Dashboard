//
//  SwiftUIView.swift
//  iOS Security Visibility Dashboard
//
//  Created by MacBook on 6/16/26.
//

import SwiftUI

struct HomeView: View {

    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                Spacer()

                Text("iOS Security Visibility Dashboard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()

                Text("Analyze iPhone diagnostic logs and view plain-language security findings.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                NavigationLink(destination: ImportLogView()) {
                    Text("Import Diagnostic Log")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                NavigationLink(destination: DashboardView(report: sampleReport)) {
                    Text("View Sample Report")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("Home")
            
            }
        }
    
}
