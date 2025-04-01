import SwiftUI
import SwiftData

struct RootView: View {
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    @State private var isShowingSplash = true
    
    var body: some View {
        Group {
            if isShowingSplash {
                SplashView()
            } else if isFirstTime {
                StartView()
            } else {
                ContentView()
            }
        }
        .modelContainer(for: Scrobble.self)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isShowingSplash = false
                }
            }
        }
    }
}