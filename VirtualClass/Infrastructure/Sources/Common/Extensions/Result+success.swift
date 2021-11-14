//
//  Result+success.swift
//  
//
//  Created by Martin on 13.11.2021.
//

import Foundation

extension Result {
    public var success: Success? { if case .success(let value) = self { return value }; return nil }
    public var failure: Failure? { if case .failure(let error) = self { return error }; return nil }
}
