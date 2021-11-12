//
//  SecureStorageQueryable.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Foundation

public protocol SecureStorageQueryable {
  var query: [String: Any] { get }
}
