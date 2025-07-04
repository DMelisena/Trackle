import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var username = ""
    @State private var password = ""
    @State private var showingRegister = false
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()

                // Logo
                Image(systemName: "function")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)

                Text("Math Quiz Master")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Test Your Mathematical Knowledge")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Spacer()

                // Login Form
                VStack(spacing: 15) {
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)

                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button("Login") {
                        if authViewModel.login(username: username, password: password) {
                            // Success handled by environment object
                        } else {
                            alertMessage = "Invalid credentials"
                            showingAlert = true
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(username.isEmpty || password.isEmpty)

                    Button("Don't have an account? Register") {
                        showingRegister = true
                    }
                    .foregroundColor(.blue)
                }
                .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .sheet(isPresented: $showingRegister) {
                RegisterView()
                    .environmentObject(authViewModel)
            }
            .alert("Error", isPresented: $showingAlert) {
                Button("OK") {}
            } message: {
                Text(alertMessage)
            }
        }
    }
}
