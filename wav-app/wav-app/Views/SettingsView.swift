import SwiftUI
struct SettingsView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = true
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToCalendar = false  // Added state for navigation
    var body: some View {
        NavigationStack {
            ZStack {
                Color(AppColors.backgroundGray).edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    syncedCalendarsButton()
                    profilePictureButton()
                    colorSelectionButton()
                    
                    Spacer()
                    
                    logOutButton()
                        .padding(.bottom, 20)
                }
                .padding(.top, 80)
            }
            .navigationDestination(isPresented: $navigateToCalendar) {
                ConnectCalendarView()
            }
        }
    }
    
    ///  Updated button to navigate using state
    private func syncedCalendarsButton() -> some View {
        Button(action: {
            print("Navigating to ConnectCalendarView")
            navigateToCalendar = true //  Triggers navigation
        }) {
            Text("Synced Calendars")
                .font(TextStyles.subheading)
                .foregroundColor(Color.white)
                .padding()
                .frame(width: 350, height: 50)
                .background(AppColors.textBlockGray)
                .cornerRadius(10)
        }
    }
    private func profilePictureButton() -> some View {
        Button(action: {
            // Action for Profile Picture Selection
        }) {
            Text("Profile Picture Selection")
                .font(TextStyles.subheading)
                .foregroundColor(Color.white)
                .padding()
                .frame(width: 350, height: 50)
                .background(AppColors.textBlockGray)
                .cornerRadius(10)
        }
    }
    private func colorSelectionButton() -> some View {
        Button(action: {
            // Action for Color Selection
        }) {
            Text("Color Selection")
                .font(TextStyles.subheading)
                .foregroundColor(Color.white)
                .padding()
                .frame(width: 350, height: 50)
                .background(AppColors.textBlockGray)
                .cornerRadius(10)
        }
    }
    private func logOutButton() -> some View {
        Button(action: {
            AuthViewModel.deleteToken()
            isLoggedIn.toggle()
        }) {
            Text("Log out")
                .font(TextStyles.subheading)
                .foregroundColor(Color.white)
                .padding()
                .frame(width: 350, height: 50)
                .background(AppColors.textBlockGray)
                .cornerRadius(10)
        }
    }
}
#Preview {
    SettingsView()
}


