//
//  UserListView.swift
//  Boilerplate
//
//  Created by Thomas on 12/3/24.
//

// Views/UserListView.swift
import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else {
                    List(viewModel.users) { user in
                        NavigationLink(destination: UserDetailView(user: user)) {
                            Text(user.name)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Users"), displayMode: .automatic)
            .onAppear {
                viewModel.fetchUsers()
            }
        }
    }
}
