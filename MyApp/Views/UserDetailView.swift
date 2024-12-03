//
//  UserDetailView.swift
//  Boilerplate
//
//  Created by Thomas on 12/3/24.
//

// Views/UserDetailView.swift
import SwiftUI

struct UserDetailView: View {
    let user: User

    var body: some View {
        VStack {
            Text("Name: \(user.name)")
                .font(.title)
            Text("Age: \(user.age)")
                .font(.subheadline)
        }
        .padding()
    }
}
