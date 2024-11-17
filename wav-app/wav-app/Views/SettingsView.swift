//
//  SettingsView.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 10/27/24.
//

import SwiftUI

extension Color {
    //might not need this at all
    static let teals = Color(red: 164 / 255, green: 255 / 255, blue: 236 / 255)
    static let oceanBlue = Color(red: 61 / 255, green: 189 / 255, blue: 255 / 255)
    static let darkGrey = Color(red: 33 / 255, green: 37 / 255, blue: 41 / 255)
    static let lightGrey = Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255)
    static let fontColor = Color(red: 60 / 255, green: 60 / 255, blue: 67 / 255) //opacity 60%
    

}



//let gradient = Gradient(colors: Color.teal)

struct SettingsView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = true // true statement gives default initialization value
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        ZStack{
            Color.black
                .ignoresSafeArea()
                //.padding(.top, 60)
            
            HStack{
                Spacer()
                homeButton()
                    .position(x: 330, y: 10)
            }

        accountButton()
            .offset(y: -300)
        
        syncdCalButton()
            .offset(y: -240)
            
        securityButton()
            .offset(y: -180)

        avatarButton()
            .offset(y: -120)
        
        accessButton()
            .offset(y: -60)
        
        languageButton()
            .offset(y: 0)
            
        notificationsButton()
            .offset(y: 60)
            
        myCalButton()
            .offset(y: 120)
                
        logOutButton()
            .offset(y: 300)
            }

        }
    func logOutButton() -> some View {
        Button(action: {
            AuthViewModel.deleteToken()
            isLoggedIn.toggle()
        }) {
            Text("Log Out")
                .font(.custom("JetBrainsMono-Regular", size: 16))
                .foregroundColor(.white)
                .padding()
                .frame(width: 350, height: 40)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(10)
                .shadow(color: Color.cyan.opacity(0.7), radius: 5, x: 0, y: 0) // Glow effect
        }
    }
    }







private func accountButton() -> some View {
    Button(action: {
        // Action for AccountButton
    }) {
        Text("Account")
            .font(.custom("JetBrainsMono-Regular", size: 34))
            .foregroundColor(.fontColor.opacity(0.6))
            .padding()
            .frame(width: 350, height: 40, alignment: .leading)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(10)
            .shadow(color: Color.cyan.opacity(0.7), radius: 5, x: 0, y: 0) // Glow effect
    }
}

private func syncdCalButton() -> some View {
    Button(action: {
        // Action for Button
    }) {
        Text("Synced Calendars")
            .font(.custom("JetBrainsMono-Regular", size: 34))
            .foregroundColor(.fontColor.opacity(0.6))
            .padding()
            .frame(width: 350, height: 40, alignment: .leading)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(10)
            .shadow(color: Color.cyan.opacity(0.7), radius: 5, x: 0, y: 0) // Glow effect
    }
}

private func securityButton() -> some View {
    Button(action: {
        // Action for Button
    }) {
        Text("Security")
            .font(.custom("JetBrainsMono-Regular", size: 34))
            .foregroundColor(.fontColor.opacity(0.6))
            .padding()
            .frame(width: 350, height: 40, alignment: .leading)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(10)
            .shadow(color: Color.cyan.opacity(0.7), radius: 5, x: 0, y: 0) // Glow effect
    }
}


private func avatarButton() -> some View {
    Button(action: {
        // Action for Button
    }) {
        Text("Avatar")
            .font(.custom("JetBrainsMono-Regular", size: 34))
            .foregroundColor(.fontColor.opacity(0.6))
            .padding()
            .frame(width: 350, height: 40, alignment: .leading)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(10)
            .shadow(color: Color.cyan.opacity(0.7), radius: 5, x: 0, y: 0) // Glow effect
    }
}

private func accessButton() -> some View {
    Button(action: {
        // Action for Button
    }) {
        Text("Accessibility")
            .font(.custom("JetBrainsMono-Regular", size: 34))
            .foregroundColor(.fontColor.opacity(0.6))
            .padding()
            .frame(width: 350, height: 40, alignment: .leading)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(10)
            .shadow(color: Color.cyan.opacity(0.7), radius: 5, x: 0, y: 0) // Glow effect
    }
}


private func languageButton() -> some View {
    Button(action: {
        // Action for Button
    }) {
        Text("Language")
            .font(.custom("JetBrainsMono-Regular", size: 34))
            .foregroundColor(.fontColor.opacity(0.6))
            .padding()
            .frame(width: 350, height: 40, alignment: .leading)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(10)
            .shadow(color: Color.cyan.opacity(0.7), radius: 5, x: 0, y: 0) // Glow effect
    }
}

private func notificationsButton() -> some View {
    Button(action: {
        // Action for Button
    }) {
        Text("Notifications")
            .font(.custom("JetBrainsMono-Regular", size: 34))
            .foregroundColor(.fontColor.opacity(0.6))
            .padding()
            .frame(width: 350, height: 40, alignment: .leading)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(10)
            .shadow(color: Color.cyan.opacity(0.7), radius: 5, x: 0, y: 0) // Glow effect
    }
}

private func myCalButton() -> some View {
    Button(action: {
        // Action for myCalButton
    }) {
        Text("My Calendar")
            .font(.custom("JetBrainsMono-Regular", size: 34))
            .foregroundColor(.fontColor.opacity(0.6))
            .padding()
            .frame(width: 350, height: 40, alignment: .leading)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(10)
            .shadow(color: Color.cyan.opacity(0.7), radius: 5, x: 0, y: 0) // Glow effect
    }
}

private func homeButton() -> some View {
    Button(action: {
        // Action for Button
    }) {
        Text("Home")
            .font(.custom("JetBrainsMono-Regular", size: 20))
            .foregroundColor(.white)
            .underline()
            .padding()
            
    }
}
#Preview {
    SettingsView()
}
