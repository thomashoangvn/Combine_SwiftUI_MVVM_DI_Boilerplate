//
//  GitHubRepository.swift
//  MyApp
//
//  Created by Thomas on 12/3/24.
//

struct GitHubRepository: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let html_url: String
    let owner: Owner
    let stargazers_count: Int
    let language: String?
    
    struct Owner: Codable {
        let id: Int
        let login: String
        let avatar_url: String
    }
}
