//
//  ErrorReportable.swift
//  
//
//  Created by Martin on 12.11.2021.
//

import Foundation

public protocol ErrorReportable: Error {
    var cause: Error { get }
    var underlyingError: Error? { get }
}
