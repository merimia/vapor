import SwiftUI

struct LoginRequest: Codable {
    let username: String
    let password: String
}

struct LoginResponse: Codable {
    let id: UUID
    let username: String
}
struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var message = ""
    @AppStorage("isLoggedIn") private var isLoggedIn = false


    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                TextField("Nom d'utilisateur", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)

                SecureField("Mot de passe", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Se connecter") {
                    Task {
                        await login()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)

                if !message.isEmpty {
                    Text(message)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }

                Spacer()
            }
            .padding()
            
            .navigationDestination(isPresented: $isLoggedIn) {
                RootView()
            }
            .navigationTitle("Connexion")
        }
    }

    func login() async {
        let loginData = LoginRequest(username: username, password: password)

        do {
            guard let url = URL(string: "http://localhost:8080/users/login") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(loginData)

            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Connexion réussie, on déclenche la navigation
                isLoggedIn = true
            } else {
                let errorMsg = String(data: data, encoding: .utf8) ?? "Erreur inconnue"
                message = "Erreur : \(errorMsg)"
            }
        } catch {
            message = "Erreur réseau : \(error.localizedDescription)"
        }
    }
}
