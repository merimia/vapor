import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favs: FavoritesManager

    var body: some View {
        NavigationView {
            if favs.favorites.isEmpty {
                Text("Aucun favori ❤️\nAjoute un cocktail depuis sa fiche !")
                    .multilineTextAlignment(.center)
                    .padding()
                    .navigationTitle("Favoris")
            } else {
                List(favs.favorites) { cocktail in
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
                .navigationTitle("Favoris")
            }
        }
    }
}
//
//  FavoritesView.swift
//  CocktailApp
//
//  Created by admin on 27/09/2025.
//

