//
//  HistoryView.swift
//  LiquidHealth
//
//  Created by Amilcar Pena Jr on 4/6/26.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "chart.bar.xaxis")
                    .font(.system(size: 60))
                    .foregroundStyle(.green)
                    .padding(.bottom, 8)
                
                Text("History Placeholder")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .navigationTitle("History")
        }
    }
}

#Preview {
    HistoryView()
}
