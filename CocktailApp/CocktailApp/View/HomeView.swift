import SwiftUI

struct HomeView: View {
    @State private var classics: [String] = ["margarita", "mojito", "bloody mary", "old fashioned"]
    @State private var classicCocktails: [Cocktail] = []
    @AppStorage("isLoggedIn") private var isLoggedIn = true

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Déconnexion") {
                        isLoggedIn = false
                    }
                    .foregroundColor(.red)
                }
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
