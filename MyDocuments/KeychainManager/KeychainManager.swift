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

     func save(credentials: Credentials) throws {

        guard let password = credentials.password.data(using: .utf8) else {
            throw KeychainError.invalidContent
        }

         let query = [kSecClass : kSecClassGenericPassword,
                 kSecAttrServer : credentials.service,
                kSecAttrAccount : credentials.user,
                  kSecValueData : password ] as CFDictionary

        let status = SecItemAdd(query, nil)

        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }

        print("saved")

    }

     func get(credentialsGet: CredentialsGet) throws -> Data? {

         let query = [kSecClass  : kSecClassGenericPassword,
                  kSecAttrServer : credentialsGet.service,
                 kSecAttrAccount : credentialsGet.user,
                  kSecReturnData : kCFBooleanTrue  as AnyObject,
                  kSecMatchLimit : kSecMatchLimitOne] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecItemNotFound else {
             throw KeychainError.notFound
         }
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }

        return result as? Data
    }
    

     func update(credentials: Credentials) throws {
        do {
            guard let passwordData = credentials.password.data(using: .utf8) else {
                throw KeychainError.unexpectedPasswordData
            }

            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: credentials.service,

            ] as CFDictionary

            let attributes = [
                kSecAttrAccount: credentials.user,
                kSecValueData: passwordData
            ] as CFDictionary

            let status = SecItemUpdate(query, attributes)

            guard status == errSecSuccess else {
                throw KeychainError.unhandledError(status: status)
            }
        } catch {
            throw error
        }
    }

}
