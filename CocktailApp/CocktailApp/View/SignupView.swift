import SwiftUI

struct SignupRequest: Codable {
    let password: String
    let username: String
}

struct SignupResponse: Codable {
    let id: UUID
    let username: String
}

struct SignupView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var message = ""
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {

                TextField("Nom d'utilisateur", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)

                SecureField("Mot de passe", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                SecureField("Confirmer le mot de passe", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Créer un compte") {
                    Task {
                        await signup()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)

                if !message.isEmpty {
                    Text(message)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }

                Spacer()

                NavigationLink(destination: LoginView()) {
                    Text("Déjà inscrit ? Se connecter")
                        .foregroundColor(.blue)
                        .underline()
                }
                .padding(.bottom, 10)
            }
            .padding()
            .navigationTitle("Créer un compte")
            .navigationDestination(isPresented: $isLoggedIn) {
                RootView()
            }
        }
    }

    func signup() async {
        guard password == confirmPassword else {
            message = "Les mots de passe ne correspondent pas."
            return
        }

        let newUser = SignupRequest(password: password, username: username)

        do {
            guard let url = URL(string: "http://localhost:8080/users/signup") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(newUser)

            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let decoded = try JSONDecoder().decode(SignupResponse.self, from: data)
                message = "Compte créé avec succès ! Bonjour \(decoded.username)"
                DispatchQueue.main.async {
                    isLoggedIn = true
                }
            } else {
                let errorMsg = String(data: data, encoding: .utf8) ?? "Erreur inconnue"
                message = "Erreur : \(errorMsg)"
            }
        } catch {
            message = "Erreur réseau : \(error.localizedDescription)"
        }
    }

}
