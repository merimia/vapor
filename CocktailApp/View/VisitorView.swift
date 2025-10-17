import SwiftUI

struct VisitorView: View {
    @State private var classics: [String] = ["margarita", "mojito", "bloody mary", "old fashioned"]
    @State private var classicCocktails: [Cocktail] = []
    
    @State private var showLogin = false
    @State private var showSignup = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // Classiques
                    if !classicCocktails.isEmpty {
                        Text("Cocktails classiques")
                            .font(.title2).bold()
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(classicCocktails) { cocktail in
                                    NavigationLink(destination: CocktailDetail(cocktail: cocktail)) {
                                        VStack {
                                            AsyncImage(url: URL(string: cocktail.strDrinkThumb ?? "")) { img in
                                                img.resizable().scaledToFill()
                                            } placeholder: {
                                                Color.gray.opacity(0.2)
                                            }
                                            .frame(width: 120, height: 120)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))

                                            Text(cocktail.strDrink)
                                                .font(.caption)
                                                .lineLimit(1)
                                                .foregroundColor(.primary)
                                        }
                                        .frame(width: 120)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle("Accueil 🍸")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("S'inscrire") {
                        showSignup = true
                    }
                    Button("Se connecter") {
                        showLogin = true
                    }
                }
            }
            .sheet(isPresented: $showSignup) {
                SignupView()
            }
            .sheet(isPresented: $showLogin) {
                LoginView()
            }
            .task {
                await loadClassics()
            }
        }
    }

    func loadClassics() async {
        var results: [Cocktail] = []
        for name in classics {
            if let first = try? await CocktailAPI.searchCocktails(name: name).first {
                results.append(first)
            }
        }
        classicCocktails = results
    }
}
