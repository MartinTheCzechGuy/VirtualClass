//
//  CourseDetailModel.swift
//  
//
//  Created by Martin on 19.11.2021.
//

import UserSDK

struct CourseDetailModel {
    let ident: String
    let name: String
    let description: String
    let lecturers: [String]
    let lessons: [String]
    let credits: Int
}

extension CourseDetailModel: Equatable {}

extension CourseDetailModel: Hashable {}
