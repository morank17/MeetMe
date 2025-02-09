import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            Color(.black).edgesIgnoringSafeArea(.all) // Dark background
            
            VStack(spacing: 30) { // Increased spacing for better alignment
                syncedCalendarsButton()
                profilePictureButton()
                colorSelectionButton()
                
                Spacer() // Pushes the log-out button to the bottom
                
                logOutButton()
                    .padding(.bottom, 20)
            }
            .padding(.top, 80) // Adjusts button placement
        }
    }
    
    private func syncedCalendarsButton() -> some View {
        Button(action: {
            // Action for Synced Calendars
        }) {
            Text("Synced Calendars")
                .font(TextStyles.subheading)
                .foregroundColor(Color.white)
                .padding()
                .frame(width: 350, height: 50)
                .background(Color.gray.opacity(0.3)) // Adjusted to match the screenshot
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
                .background(Color.gray.opacity(0.3)) // Matching UI style
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
                .background(Color.gray.opacity(0.3)) // Matching UI style
                .cornerRadius(10)
        }
    }
    
    private func logOutButton() -> some View {
        Button(action: {
            // Log-out action
        }) {
            Text("Log out")
                .font(TextStyles.subheading)
                .foregroundColor(Color.white)
                .padding()
                .frame(width: 350, height: 50)
                .background(Color.gray.opacity(0.3)) // Matching UI style
                .cornerRadius(10)
        }
    }
}

#Preview {
    SettingsView()
}

