//
//  GitHubListViewModel.swift
//  MyApp
//
//  Created by Thomas on 12/3/24.
//

import Combine
import SwiftUI

enum SortOption {
    case id
    case name
    case stargazers
    case language
}

class GitHubListViewModel: ObservableObject {
    @Published var repositories: [GitHubRepository] = []
    @Published var isLoadingPage = false
    @Published var sortOption: SortOption = .id {
        didSet {
            sortRepositories()
        }
    }
    @Published var errorMessage: String?
    @Published var networkMonitor: NetworkMonitor
    private var cancellables = Set<AnyCancellable>()
    private let gitHubService: GitHubServiceProtocol
    private var currentPage = 1
    private let perPage = 10
    private var canLoadMorePages = true
    
    init(gitHubService: GitHubServiceProtocol, networkMonitor: NetworkMonitor) {
        self.gitHubService = gitHubService
        self.networkMonitor = networkMonitor
        observeNetworkStatus()
        fetchRepositories()
    }
    
    private func observeNetworkStatus() {
        networkMonitor.$isConnected
            .sink { [weak self] isConnected in
                if isConnected {
                    self?.errorMessage = nil
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchRepositories() {
        guard !isLoadingPage && canLoadMorePages else { return }
        
        if !networkMonitor.isConnected {
            return
        }
        
        isLoadingPage = true
        
        gitHubService.fetchRepositories(page: currentPage, perPage: perPage)
            .sink(receiveCompletion: { completion in
                self.isLoadingPage = false
                if case .failure(let error) = completion {
                    self.errorMessage = "Failed to load data: \(error.localizedDescription)"
                    self.canLoadMorePages = false
                }
            }, receiveValue: { [weak self] repositories in
                guard let self = self else { return }
                self.repositories.append(contentsOf: repositories)
                self.sortRepositories()
                self.isLoadingPage = false
                self.canLoadMorePages = repositories.count == self.perPage
                self.currentPage += 1
            })
            .store(in: &cancellables)
    }
    
    func refresh() {
        repositories.removeAll()
        currentPage = 1
        canLoadMorePages = true
        fetchRepositories()
    }
    
    private func sortRepositories() {
        switch sortOption {
        case .id:
            repositories.sort { $0.id < $1.id }
        case .name:
            repositories.sort { $0.name.lowercased() < $1.name.lowercased() }
        case .stargazers:
            repositories.sort { $0.stargazers_count > $1.stargazers_count }
        case .language:
            repositories.sort { ($0.language ?? "").lowercased() < ($1.language ?? "").lowercased() }
        }
    }
}
