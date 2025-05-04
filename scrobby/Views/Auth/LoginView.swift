import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Sign in to Scrobby")
                .font(.title)
                .fontWeight(.bold)

            VStack(alignment: .leading, spacing: 12) {
                Text("Last.fm Account")
                    .font(.headline)

                TextField("Username", text: $viewModel.lastfmUsername)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)

                SecureField("Password", text: $viewModel.lastfmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    Task {
                        await viewModel.signInToLastFm()
                    }
                }) {
                    HStack {
                        Image(systemName: "music.note")
                        Text("Sign in to Last.fm")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding(.vertical)

            SignInWithAppleButton { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                Task {
                    await viewModel.handleSignInWithAppleResult(result)
                }
            }
            .frame(height: 50)
            .padding(.horizontal)

            if viewModel.isLoading {
                ProgressView()
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding()
    }
}