//
//  SplashView.swift
//  scrobby
//
//  Created by Bennett Nguyen on 3/28/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.accentColor
                .ignoresSafeArea()
            VStack {
                Text("Scrobby")
                    .font(.custom("Batrade", size: 40))
                    .foregroundColor(.white)
            }
        }
    }
}
