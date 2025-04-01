import SwiftUI

struct StartView: View {
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true

    var body: some View {
        ZStack {
            Color.accentColor
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Text("Welcome to Scrobby")
                    .foregroundColor(.white)

                VStack(spacing: 15) {
                    Text("Scrobble your listening history")
                        .font(.title2)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Button(action: {
                        withAnimation {
                            isFirstTime = false
                        }
                    }) {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 30)
                    }
                }
            }
        }
    }
}