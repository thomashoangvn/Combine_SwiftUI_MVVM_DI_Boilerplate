//
//  GitHubService.swift
//  MyApp
//
//  Created by Thomas on 12/3/24.
//

import Combine
import Foundation

protocol GitHubServiceProtocol {
    func fetchRepositories(page: Int, perPage: Int) -> AnyPublisher<[GitHubRepository], Error>
}

class GitHubService: GitHubServiceProtocol {
    func fetchRepositories(page: Int, perPage: Int) -> AnyPublisher<[GitHubRepository], Error> {
        //let url = URL(string: "https://api.github.com/users/thomashoangvn/repos?page=\(page)&per_page=\(perPage)")!
        let url = URL(string: "https://api.github.com/users/firebase/repos?page=\(page)&per_page=\(perPage)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { output in
                self.printResponseData(output.data)
                return output.data
            }
            .decode(type: [GitHubRepository].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func printResponseData(_ data: Data) {
#if DEBUG
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let prettyPrintedString = String(data: jsonData, encoding: .utf8) {
            print("Response JSON:\n\(prettyPrintedString)")
        }
#endif
    }
}
