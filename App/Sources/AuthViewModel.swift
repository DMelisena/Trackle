import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoggedIn = false
    @Published var users: [User] = [
        User(username: "teacher1", password: "pass123", role: .teacher, name: "Dr. Smith"),
        User(username: "student1", password: "pass123", role: .student, name: "John Doe"),
    ]

    func login(username: String, password: String) -> Bool {
        if let user = users.first(where: { $0.username == username && $0.password == password }) {
            currentUser = user
            isLoggedIn = true
            return true
        }
        return false
    }

    func register(username: String, password: String, name: String, role: UserRole) -> Bool {
        if users.contains(where: { $0.username == username }) {
            return false
        }
        let newUser = User(username: username, password: password, role: role, name: name)
        users.append(newUser)
        return true
    }

    func logout() {
        currentUser = nil
        isLoggedIn = false
    }
}
