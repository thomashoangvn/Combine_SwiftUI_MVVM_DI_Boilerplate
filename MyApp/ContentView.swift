//
//  ContentView.swift
//  MyApp
//
//  Created by Thomas on 12/3/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GitHubListView(viewModel: GitHubListViewModel(
            gitHubService: GitHubService(),
            networkMonitor: NetworkMonitor()
        ))
    }
}

#Preview {
    ContentView()
}
