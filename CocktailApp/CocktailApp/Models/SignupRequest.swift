//
//  SignupRequest.swift
//  CocktailApp
//
//  Created by admin on 27/09/2025.
//


import Foundation

func signupUser( password: String, username: String) async throws -> SignupResponse {
    guard let url = URL(string: "http://localhost:8080/users/signup") else {
        throw URLError(.badURL)
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body = SignupRequest( password: password, username: username)
    request.httpBody = try JSONEncoder().encode(body)

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }

    let decoded = try JSONDecoder().decode(SignupResponse.self, from: data)
    return decoded
}
