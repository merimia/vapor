//
//  RootView.swift
//  CocktailApp
//
//  Created by admin on 17/10/2025.
//
import SwiftUI

struct RootView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some View {
        NavigationStack {
            if isLoggedIn {
                HomeView()
                    .navigationBarBackButtonHidden(true)

            } else {
                VisitorView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}
