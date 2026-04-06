//
//  DashboardView.swift
//  LiquidHealth
//
//  Created by Amilcar Pena Jr on 4/6/26.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "drop.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)
                    .padding(.bottom, 8)
                
                Text("Dashboard Placeholder")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .navigationTitle("Dashboard")
        }
    }
}

#Preview {
    DashboardView()
}
