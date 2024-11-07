//
//  AuthViewModel.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 11/7/24.
//

import Foundation
import Security

class AuthViewModel {
    
    // Save token securely in Keychain
    static func saveToken(token: String) {
        let tokenData = token.data(using: .utf8)!
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "authToken",
            kSecValueData: tokenData
        ] as CFDictionary

        SecItemDelete(query) // Ensure any existing token is removed before saving
        SecItemAdd(query, nil)
    }
    
    // Retrieve token securely from Keychain
    static func retrieveToken() -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "authToken",
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var dataTypeRef: AnyObject? = nil
        let status = SecItemCopyMatching(query, &dataTypeRef)

        if status == errSecSuccess {
            if let tokenData = dataTypeRef as? Data {
                return String(data: tokenData, encoding: .utf8)
            }
        }
        return nil
    }
    
    // Delete token securely from Keychain
    static func deleteToken() {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "authToken"
        ] as CFDictionary

        SecItemDelete(query)
    }
}
