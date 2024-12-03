//
//  UserViewModel.swift
//  Boilerplate
//
//  Created by Thomas on 12/3/24.
//

// ViewModels/UserViewModel.swift
import Combine
import Foundation

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()
    private let userService: UserServiceProtocol

    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }

    func fetchUsers() {
        isLoading = true
        userService.fetchUsers()
            .sink { [weak self] users in
                self?.users = users
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
}
