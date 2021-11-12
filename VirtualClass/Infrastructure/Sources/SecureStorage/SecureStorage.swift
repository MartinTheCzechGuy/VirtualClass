//
//  SecureStorage.swift
//  
//
//  Created by Martin on 11.11.2021.
//

public protocol SecureStorage {
    func getValue(for userAccount: String) throws -> String?
    func setValue(_ value: String, for userAccount: String) throws
    func removeValue(for userAccount: String) throws
    func removeAllValues() throws
}
