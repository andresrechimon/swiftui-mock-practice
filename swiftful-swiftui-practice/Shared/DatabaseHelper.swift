//
//  DatabaseHelper.swift
//  swiftful-swiftui-practice
//
//  Created by Andres Rechimon on 26/05/2024.
//

import Foundation

struct DatabaseHelper {
    func getUsers() async throws -> [User] {
        guard let url = URL(string: "https://dummyjson.com/users") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let users = try JSONDecoder().decode(UserArray.self, from: data)
        dump(users)
        return users.users
    }
}



