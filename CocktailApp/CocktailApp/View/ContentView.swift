import SwiftUI

struct ContentView: View {
    @State private var query = ""
    @State private var cocktails: [Cocktail] = []
    @State private var loading = false
    @State private var randomCocktail: Cocktail?

    var body: some View {
        NavigationView {
            VStack {
                // Barre de recherche
                HStack {
                    TextField("Rechercher un cocktail…", text: $query)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .onSubmit { Task { await doSearch() } }

                    Button {
                        Task { await doSearch() }
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                    .padding(.trailing)
                }

                           

                // Liste résultats
                List(cocktails) { cocktail in
                    NavigationLink(destination: CocktailDetail(cocktail: cocktail)) {
                        HStack {
                            AsyncImage(url: URL(string: cocktail.strDrinkThumb ?? "")) { img in
                                img.resizable().scaledToFill()
                            } placeholder: {
                                Color.gray.opacity(0.2)
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                            Text(cocktail.strDrink)
                                .font(.headline)
                        }
                    }
                }
            }
            .navigationTitle("Recherche 🔍")
        }
    }

    func doSearch() async {
        loading = true
        defer { loading = false }
        do {
            cocktails = try await CocktailAPI.searchCocktails(name: query)
            randomCocktail = nil
        } catch {
            print("Erreur API:", error)
        }
    }

    func loadRandom() async {
        loading = true
        defer { loading = false }
        do {
            randomCocktail = try await CocktailAPI.randomCocktail()
            cocktails = []
        } catch {
            print("Erreur API:", error)
        }
    }
}
