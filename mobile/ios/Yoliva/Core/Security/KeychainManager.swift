// mobile/ios/Yoliva/Core/Security/KeychainManager.swift
import Foundation
import Security

/// Secure Keychain implementation for sensitive data storage (JWT Tokens, PII).
final class KeychainManager {
    static let shared = KeychainManager()
    private init() {}
    
    /// Save a string value to the Keychain.
    /// - Parameters:
    ///   - value: The string to store.
    ///   - key: The key associated with the value.
    func save(_ value: String, for key: String) {
        let data = Data(value.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock // Allow storage after first device unlock
        ]
        
        // Remove existing item to avoid duplicates
        SecItemDelete(query as CFDictionary)
        
        // Add new item to Keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("Keychain Error: Failed to save data for key \(key), status code: \(status)")
        }
    }
    
    /// Retrieve a string value from the Keychain.
    /// - Parameter key: The key associated with the value.
    /// - Returns: The string if found, otherwise nil.
    func retrieve(for key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kSecBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    /// Delete a value from the Keychain.
    /// - Parameter key: The key associated with the value.
    func delete(for key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
