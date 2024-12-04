//
//  GitHubListView.swift
//  MyApp
//
//  Created by Thomas on 12/3/24.
//

import SwiftUI

struct GitHubListView: View {
    @StateObject var viewModel: GitHubListViewModel
    @State private var isSortMenuPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                List {
                    ForEach(viewModel.repositories.indices, id: \.self) { index in
                        let repository = viewModel.repositories[index]
                        NavigationLink(destination: DetailRepositoryView(repository: repository)) {
                            HStack {
                                CachedAsyncImage(url: URL(string: repository.owner.avatar_url))
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading) {
                                    Text(repository.name)
                                        .font(.headline)
                                    Text(repository.owner.login)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    HStack {
                                        Text("⭐️ \(repository.stargazers_count)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        if let language = repository.language {
                                            Text("• \(language)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                            }
                        }
                        .onAppear {
                            // Check if the repository is the last item
                            if index == viewModel.repositories.count - 1 {
                                viewModel.fetchRepositories()
                            }
                        }
                    }
                    if viewModel.isLoadingPage {
                        ProgressView()
                    }
                }
                .refreshable {
                    viewModel.refresh()
                }
            }
            .navigationTitle("Repositories")
            .navigationBarItems(trailing: Menu {
                Button(action: {
                    viewModel.sortOption = .id
                }) {
                    Text("ID")
                }
                Button(action: {
                    viewModel.sortOption = .name
                }) {
                    Text("Name")
                }
                Button(action: {
                    viewModel.sortOption = .stargazers
                }) {
                    Text("Stargazers")
                }
                Button(action: {
                    viewModel.sortOption = .language
                }) {
                    Text("Language")
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .imageScale(.large)
            })
            .overlay(
                ToastView(message: viewModel.networkMonitor.toastMessage ?? "", isShowing: $viewModel.networkMonitor.isShowingToast)
            )
        }
        .onAppear {
            viewModel.fetchRepositories()
        }
    }
}
