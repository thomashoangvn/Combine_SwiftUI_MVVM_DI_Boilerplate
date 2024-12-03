//
//  UserService.swift
//  Boilerplate
//
//  Created by Thomas on 12/3/24.
//

// Services/UserService.swift
import Combine
import Foundation

protocol UserServiceProtocol {
    func fetchUsers() -> AnyPublisher<[User], Never>
}

class UserService: UserServiceProtocol {
    func fetchUsers() -> AnyPublisher<[User], Never> {
        let users = [
            User(id: UUID(), name: "Alice", age: 25),
            User(id: UUID(), name: "Bob", age: 30),
            User(id: UUID(), name: "Charlie", age: 35)
        ]
        return Just(users)
            .delay(for: .seconds(1), scheduler: DispatchQueue.main) //Mock delay
            .eraseToAnyPublisher()
    }
}
