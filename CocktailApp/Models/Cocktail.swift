import Foundation
struct Cocktail: Identifiable, Codable, Equatable {
    let idDrink: String?
    let strDrink: String
    let strDrinkThumb: String?
    let strInstructions: String?

    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?

    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
    let strMeasure6: String?
    let strMeasure7: String?
    let strMeasure8: String?
    let strMeasure9: String?
    let strMeasure10: String?
    let strMeasure11: String?
    let strMeasure12: String?
    let strMeasure13: String?
    let strMeasure14: String?
    let strMeasure15: String?

    /// 👇 identifiant stable
    var id: String {
        idDrink ?? (strDrink + (strIngredient1 ?? ""))
    }

    var ingredients: [Ingredient] {
        let ingredientsArray = [
            strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5,
            strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10,
            strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15
        ]
        let measuresArray = [
            strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5,
            strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10,
            strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15
        ]

        var items: [Ingredient] = []

        for i in 0..<15 {
            if let ing = ingredientsArray[i], !ing.trimmingCharacters(in: .whitespaces).isEmpty {
                let meas = measuresArray[i]?.trimmingCharacters(in: .whitespaces) ?? ""
                items.append(Ingredient(name: ing, measure: meas))
            }
        }
        return items
    }
}


struct Ingredient: Identifiable, Codable {
    let id = UUID()
    let name: String
    let measure: String
}


struct CocktailResponse: Codable {
    let drinks: [Cocktail]?
}
