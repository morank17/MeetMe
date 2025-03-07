import SwiftUI
import EventKit
import SafariServices

struct ConnectCalendarView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var googleSignInURL: String = ""
    @State private var navigateToHome = false
    @State private var isGoogleLoggedIn = false
    @State private var isAppleLoggedIn = false
    private let fetcher = CalendarFetcher()
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundGray.edgesIgnoringSafeArea(.all)
                VStack(spacing: 30) {
                    Text("Connect a Calendar Account")
                        .font(TextStyles.heading)
                        .foregroundColor(Color.white)
                        .padding()
                    
                    HStack(spacing: 30) {
                        // Google Sign-In Button
                        Button(action: {
                            Task {
                                await handleGoogleSignIn()
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
                                
                                if isGoogleLoggedIn {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .offset(x: 30, y: -30) // ✅ Positioning the checkmark
                                }
                            }
                        }
                        
                        // Apple Calendar Button - Requests Full Access
                        Button(action: {
                            Task {
                                let granted = await fetcher.requestFullCalendarAccess()
                                DispatchQueue.main.async {
                                    isAppleLoggedIn = granted
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
                                
                                if isAppleLoggedIn {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .offset(x: 30, y: -30) // ✅ Positioning the checkmark
                                }
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
                    
                }
                .onAppear {
                    Task {
                        await checkAppleCalendarAccess()
                        await checkGoogleLoginStatus()
                    }
                }
                .navigationDestination(isPresented: $navigateToHome) {
                    HomeView()
                }
            }
        }
    }
    
    /// **Handles Google Sign-In: Checks First, Then Signs In if Needed**
    func handleGoogleSignIn() async {
        await checkGoogleLoginStatus() // First, check if user is logged in
        
        if isGoogleLoggedIn {
            print("✅ User already authenticated with Google Calendar. No sign-in needed.")
            return // Exit function since user is already logged in
        }

        // If not logged in, proceed with Google authentication
        do {
            googleSignInURL = try await getGoogleSignInURL()
            
            if let rootViewController = UIApplication.shared.connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.windows.first?.rootViewController })
                .first {
                startSignInWithGoogle(from: rootViewController)
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    /// Checks Apple Calendar access on view load
    func checkAppleCalendarAccess() async {
        let status = EKEventStore.authorizationStatus(for: .event)
        
        DispatchQueue.main.async {
            if status == .fullAccess {
                isAppleLoggedIn = true
            } else {
                isAppleLoggedIn = false
            }
        }
    }
    
    /// **Check Google Login Status via API**
    func checkGoogleLoginStatus() async {
        guard let token = AuthViewModel.retrieveToken() else {
            print("⚠️ No auth token found")
            return
        }
        
        let urlString = "https://musketeers-django.onrender.com/api/users/check-google-creds?token=\(token)"
        
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let loggedIn = jsonObject?["success"] as? Bool {
                    DispatchQueue.main.async {
                        isGoogleLoggedIn = loggedIn
                    }
                }
            } else {
                print("❌ Server Error: \(response)")
            }
        } catch {
            print("❌ API Call Failed: \(error)")
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
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = viewController as? SFSafariViewControllerDelegate
        safariVC.modalPresentationStyle = .formSheet
        viewController.present(safariVC, animated: true, completion: nil)
    }
}

// ✅ SafariViewController Extension for Google Login Handling
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
