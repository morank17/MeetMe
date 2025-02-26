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
                                                
                                                // Get the root view controller and present Safari pop-up from it
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
//                    Button {
//                        Task {
//                            await testAddAppleEvent()
//                        }
//                    } label: {
//                        Text("Test Add Apple Event")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .padding()
//                            .frame(maxWidth: .infinity) // Makes it stretch if needed
//                            .background(Color.green)
//                            .cornerRadius(10)
//                    }
                    // Apple Calendar Button - Requests Full Access
                    Button(action: {
                        Task {
                            let accessGranted = await fetcher.requestFullCalendarAccess()
                            DispatchQueue.main.async {
                                loginMessage = accessGranted ? "Connected to Apple Calendar ✅" : "Access Denied ❌"
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

                // Test Fetch Calendar Events Button
                // Comment this out
//                Button(action: {
//                    Task {
//                        await testFetchCalendarEvents()
//                    }
//                }) {
//                    Text("Test Fetch Calendar Events")
//                        .padding()
//                        .foregroundColor(.white)
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                }

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

    /// Tests fetching calendar events and prints the JSON to the console.
    /// Comment this out
//    func testFetchCalendarEvents() async {
//        let calendar = Calendar.current
//        let today = Date()
//        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
//        let timeZone = "America/New_York" // Set the timezone to EST
//
//        print("📅 Fetching calendar events for today and tomorrow in \(timeZone)...")
//
//        await fetcher.fetchCalendarEvents(for: [today, tomorrow], withTimeZone: timeZone)
//    }


    /// Checks Apple Calendar access
    func checkAppleCalendarAccess() async {
        let status = EKEventStore.authorizationStatus(for: .event)

        DispatchQueue.main.async {
            if status == .fullAccess {
                loginMessage = "Connected to Apple Calendar ✅"
            } else {
                loginMessage = "Not Logged In to Calendar ❌"
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
    
    
    
    
//    func testAddAppleEvent() async {
//        let title = "Test Meeting 1"
//        let winningStartDateTime = "2025-02-28T09:00:00Z"  // ISO 8601 UTC format
//        let winningEndDateTime = "2025-02-28T10:00:00Z"    // ISO 8601 UTC format
//        let timeZoneStr = "-5:00"  // The timezone of the given input (e.g., EST)
//        let participants = ["alice@example.com", "bob@example.com", "charlie@example.com"]
//        let loginCode = "ZTR-C1U"
//        
//        print("📅 Attempting to create test event in Apple Calendar...")
//        
//        await fetcher.createAppleEvent(title: title,
//                                       winningStartDateTime: winningStartDateTime,
//                                       winningEndDateTime: winningEndDateTime,
//                                       timeZoneStr: timeZoneStr,
//                                       participants: participants, loginCode: loginCode)
//        
//        print("✅ Test event creation complete.")
//    }
    
    
    
    
    
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

    // ✅ Extend the ViewController to Detect Redirects and Close the Pop-Up
    extension UIViewController: SFSafariViewControllerDelegate {
        // Detects when the user is redirected to a new page inside the Safari pop-up
        public func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
            print("🔄 Redirect detected: \(URL.absoluteString)")

            // Check if the URL contains Google Auth Callback and a Code
            if URL.absoluteString.contains("google_auth_callback") && URL.absoluteString.contains("code=") {
                print("✅ Authentication Successful - Closing Pop-up")
                controller.dismiss(animated: true, completion: nil)
            }
        }

        // Detects when the user manually closes the pop-up
        public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            print("❌ User manually closed the pop-up")
        }
    }


#Preview {
    ConnectCalendarView()
}
