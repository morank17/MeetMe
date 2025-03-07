import SwiftUI
import EventKit
import SafariServices

struct ConnectCalendarView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var loginMessage = "Not Logged In to Calendar"
    @State private var googleSignInURL: String = ""
    @State private var navigateToHome = false
    private let fetcher = CalendarFetcher()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("Connect a Calendar Account")
                    .font(.title)
                    .padding()
                
                HStack(spacing: 30) {
                    // Google Sign-In Button
                    Button(action: {
                        Task {
                            do {
                                googleSignInURL = try await getGoogleSignInURL()
                                
                                if let rootViewController = UIApplication.shared.connectedScenes
                                    .compactMap({ ($0 as? UIWindowScene)?.windows.first?.rootViewController })
                                    .first {
                                    startSignInWithGoogle(from: rootViewController)
                                }
                            } catch {
                                loginMessage = "Failed to get sign-in URL. Please try again."
                                print("Error: \(error)")
                            }
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 100, height: 100)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                            Image("GoogleIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        }
                    }
                    
                    // Apple Calendar Button - Requests Full Access
                    Button(action: {
                        Task {
                            let granted = await fetcher.requestFullCalendarAccess()
                            DispatchQueue.main.async {
                                loginMessage = granted ? "Connected to Apple Calendar ✅" : "Access Denied ❌"
                            }
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 100, height: 100)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                            Image("AppleIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45, height: 45)
                        }
                    }
                }
                
                // Continue Button (Navigates to HomeView)
                Button(action: {
                    isLoggedIn = true
                    navigateToHome = true
                }) {
                    Text("Continue")
                }
                .padding(.vertical, 1)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(AppColors.blueGradient)
                .cornerRadius(30)
                .padding(.horizontal, 60)
                
                // Display Login Message
                Text(loginMessage)
                    .foregroundColor(.gray)
                    .padding(20)
            }
            .onAppear {
                Task {
                    await checkAppleCalendarAccess()
                }
            }
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView()
            }
        }
    }
    
    /// Checks Apple Calendar access on view load
    func checkAppleCalendarAccess() async {
        let status = EKEventStore.authorizationStatus(for: .event)
        
        DispatchQueue.main.async {
            if status == .fullAccess {
                loginMessage = "Connected to Apple Calendar ✅"
            } else {
                loginMessage = "Press the Continue button"
            }
        }
    }
    
    func getGoogleSignInURL() async throws -> String {
        let url = URL(string: "https://musketeers-django.onrender.com/api/users/google-register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let token = AuthViewModel.retrieveToken() ?? "default_token"
        let bodyString = "token=\(token)"
        request.httpBody = bodyString.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw URLError(.badServerResponse)
        }
        
        guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let authUrl = jsonObject["auth_url"] as? String else {
            throw URLError(.cannotParseResponse)
        }
        return authUrl
    }
    
    func startSignInWithGoogle(from viewController: UIViewController) {
        print("Running sign in with Google")
        print(googleSignInURL)
        
        guard let url = URL(string: googleSignInURL) else {
            loginMessage = "Invalid Sign-In URL"
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = viewController as? SFSafariViewControllerDelegate
        safariVC.modalPresentationStyle = .formSheet // Makes it a pop-up instead of full screen
        viewController.present(safariVC, animated: true, completion: nil)
    }

}

// ✅ This must be outside the struct
extension UIViewController: SFSafariViewControllerDelegate {
    public func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        print("🔄 Redirect detected: \(URL.absoluteString)")

        if URL.absoluteString.contains("google_auth_callback") && URL.absoluteString.contains("code=") {
            print("✅ Authentication Successful - Closing Pop-up")
            controller.dismiss(animated: true, completion: nil)
        }
    }

    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        print("❌ User manually closed the pop-up")
    }
}

// Preview
#Preview {
    ConnectCalendarView()
}

