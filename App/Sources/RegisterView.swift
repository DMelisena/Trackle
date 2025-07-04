import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var username = ""
    @State private var password = ""
    @State private var name = ""
    @State private var selectedRole = UserRole.student
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                VStack(spacing: 15) {
                    TextField("Full Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)

                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Picker("Role", selection: $selectedRole) {
                        ForEach(UserRole.allCases, id: \.self) { role in
                            Text(role.rawValue).tag(role)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    Button("Register") {
                        if authViewModel.register(username: username, password: password, name: name, role: selectedRole) {
                            alertMessage = "Registration successful! Please login."
                            showingAlert = true
                        } else {
                            alertMessage = "Username already exists"
                            showingAlert = true
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(username.isEmpty || password.isEmpty || name.isEmpty)
                }
                .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() }
            )
            .alert("Registration", isPresented: $showingAlert) {
                Button("OK") {
                    if alertMessage.contains("successful") {
                        dismiss()
                    }
                }
            } message: {
                Text(alertMessage)
            }
        }
    }
}
