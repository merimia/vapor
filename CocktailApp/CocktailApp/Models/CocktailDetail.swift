import SwiftUI

struct CocktailDetail: View {
    let cocktail: Cocktail
    @EnvironmentObject var favs: FavoritesManager

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Image
                AsyncImage(url: URL(string: cocktail.strDrinkThumb ?? "")) { img in
                    img.resizable().scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(height: 250)
                .clipped()
                .cornerRadius(12)
                .padding(.horizontal)

                // Nom + favoris
                HStack {
                    Text(cocktail.strDrink)
                        .font(.title)
                        .bold()
                        .padding(.horizontal)

                    Spacer()

                    Button {
                        favs.toggle(cocktail)
                    } label: {
                        Image(systemName: favs.isFavorite(cocktail) ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                            .font(.title2)
                            .padding(.trailing)
                    }
                }

                // Ingrédients
                if !cocktail.ingredients.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ingrédients")
                            .font(.headline)

                        ForEach(cocktail.ingredients) { item in
                            Text("• \(item.measure.isEmpty ? "" : item.measure + " ") \(item.name)")

                        }
                    }
                    .padding(.horizontal)
                }

                // Instructions
                if let instructions = cocktail.strInstructions {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Préparation")
                            .font(.headline)

                        Text(instructions)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(cocktail.strDrink)
        .navigationBarTitleDisplayMode(.inline)
    }
}
