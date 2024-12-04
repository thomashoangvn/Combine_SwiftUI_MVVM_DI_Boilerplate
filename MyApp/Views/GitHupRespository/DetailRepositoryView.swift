//
//  DetailRepositoryView.swift
//  MyApp
//
//  Created by Thomas on 12/3/24.
//

import SwiftUI

struct DetailRepositoryView: View {
    let repository: GitHubRepository
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                CachedAsyncImage(url: URL(string: repository.owner.avatar_url))
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(repository.owner.login)
                        .font(.title)
                    Text("⭐️ \(repository.stargazers_count) stars")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom, 10)
            
            Text(repository.name)
                .font(.largeTitle)
                .padding(.bottom, 5)
            
            if let description = repository.description {
                Text(description)
                    .padding(.bottom, 5)
            }
            
            if let language = repository.language {
                Text("Written in \(language)")
                    .padding(.bottom, 5)
            }
            
            Spacer()
            
            Link("View on GitHub", destination: URL(string: repository.html_url)!)
                .font(.headline)
                .padding(.top, 10)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Repository Details")
    }
}
