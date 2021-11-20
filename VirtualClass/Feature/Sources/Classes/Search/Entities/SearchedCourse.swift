//
//  SearchedCourse.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Foundation

struct SearchedCourse: Identifiable {
    let ident: String
    let name: String
    var isSelected: Bool
    
    var id: String {
        ident
    }
}

extension SearchedCourse: Hashable {}
