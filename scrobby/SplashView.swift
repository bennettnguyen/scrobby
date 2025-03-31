//
//  SplashView.swift
//  scrobby
//
//  Created by Bennett Nguyen on 3/28/25.
//

import SwiftUI
import SwiftData

struct SplashView: View {
    @State private var isActive: Bool = false
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                Color.accentColor
                    .ignoresSafeArea()
                VStack {
                    Text("Scrobby")
                        .font(.custom("Batrade", size: 40))
                        .foregroundColor(.white)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}
