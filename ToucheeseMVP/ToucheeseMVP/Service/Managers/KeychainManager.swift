//
//  KeychainManager.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/23/24.
//

import Foundation
import Security

final class KeychainManager {
    
    static let shared = KeychainManager()
    private init() {}
    
    private let serviceName = "touchcheese"
    
    @discardableResult
    /// 기존에 토큰이 있는 경우 ->  업데이트
    /// 기존에 토큰이 없는 경우 ->  생성
    func updateOrCreate(token: String, forAccount account: AccountType) -> Bool {
        if !update(token: token, forAccount: account) {
            return create(token: token, forAccount: account)
        }
        
        return true
    }
    
    @discardableResult
    func create(token: String, forAccount account: AccountType) -> Bool {
        delete(forAccount: account)
        
        let keychainQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account.rawValue,
            kSecAttrService: serviceName,
            kSecValueData: token.data(using: .utf8) as Any
        ] as [String: Any]
        
        let status = SecItemAdd(keychainQuery as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            print("Keychain create Error")
            return false
        }
        
        print("Keychain create Success")
        return true
    }
    
    func read(forAccount account: AccountType) -> String? {
        let keychainQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account.rawValue,
            kSecAttrService: serviceName,
            kSecReturnData: true
        ] as [String: Any]
        
        var data: AnyObject?
        let status = SecItemCopyMatching(keychainQuery as CFDictionary, &data)
        
        if status == errSecSuccess {
            return String(data: data as! Data, encoding: .utf8)
        }
        
        if status == errSecItemNotFound {
            print("The token was not found in keychain")
            return nil
        } else {
            print("Error getting token from keychain: \(status)")
            return nil
        }
    }
    
    @discardableResult
    func update(token: String, forAccount account: AccountType) -> Bool {
        let keychainQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account.rawValue,
            kSecAttrService: serviceName
        ] as [String: Any]
        
        let updateAttributes = [
            kSecValueData: token.data(using: .utf8) as Any
        ] as [String: Any]
        
        let status = SecItemUpdate(
            keychainQuery as CFDictionary,
            updateAttributes as CFDictionary
        )
        
        guard status != errSecItemNotFound else {
            print("The token was not found in keychain")
            return false
        }
        
        guard status == errSecSuccess else {
            print("Keychain update error: \(status)")
            return false
        }
        
        print("The token in keychain is updated")
        return true
    }
    
    @discardableResult
    func delete(forAccount account: AccountType) -> Bool {
        let keychainQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceName,
            kSecAttrAccount: account.rawValue
        ] as [String: Any]
        
        let status = SecItemDelete(keychainQuery as CFDictionary)
        
        guard status != errSecItemNotFound else {
            print("The token was not found in keychain")
            return false
        }
        guard status == errSecSuccess else {
            print("Keychain delete Error")
            return false
        }
        print("The token in keychain is deleted")
        return true
    }
    
}

enum AccountType: String {
    case accessToken
    case refreshToken
    case deviceId
}
