//
//  SettingsView.swift
//  LiquidHealth
//
//  Created by Amilcar Pena Jr on 4/6/26.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 60))
                    .foregroundStyle(.gray)
                    .padding(.bottom, 8)
                
                Text("Settings Placeholder")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
