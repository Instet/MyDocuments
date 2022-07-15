//
//  KeychainManager.swift
//  MyDocuments
//
//  Created by Руслан Магомедов on 09.07.2022.
//

import Foundation
import Security

enum KeychainError: Error {
    case invalidContent
    case duplicateEntry
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
    case notFound
}

class KeychainManager {

    let kSecClassValue = NSString(format: kSecClass)
    let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
    let kSecValueDataValue = NSString(format: kSecValueData)
    let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
    let kSecAttrServiceValue = NSString(format: kSecAttrService)
    let kSecReturnAttributesValue = NSString(format: kSecReturnAttributes)
    let kSecReturnDataValue = NSString(format: kSecReturnData)


    func save(credentials: Credentials) throws {

        guard let password = credentials.password.data(using: .utf8) else {
            throw KeychainError.invalidContent
        }

        let query: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, credentials.service, credentials.user, password], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])

        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)

        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
        print("saved")
    }

    
    func get(credentialsGet: String) throws -> String? {


        let query: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, credentialsGet, true, true], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecReturnAttributesValue, kSecReturnDataValue])

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }

        guard let existingItem = item as? [String : Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let _ = existingItem[kSecAttrAccount as String] as? String
        else {
            throw KeychainError.unexpectedPasswordData
        }
       
        return password

    }
    

    func update(credentials: Credentials) throws {
        do {
            guard let passwordData = credentials.password.data(using: .utf8) else {
                throw KeychainError.unexpectedPasswordData
            }

            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: credentials.service,
                kSecAttrAccount: credentials.user,
                kSecValueData: passwordData
            ] as CFDictionary

            let status = SecItemDelete(query)

            guard status == errSecSuccess else {
                throw KeychainError.unhandledError(status: status)
            }


        } catch {
            throw error
        }

    }

}
