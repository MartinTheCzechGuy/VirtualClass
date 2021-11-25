//
//  Faculty+background.swift
//  
//
//  Created by Martin on 20.11.2021.
//

import UserSDK
import SwiftUI

extension GenericFaculty {
    var background: LinearGradient {
        switch self {
        case .facultyOfEconomics:
            return LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color(red: 0.6544341662, green: 0.9271220419, blue: 0.9764705896, opacity: 1),
                        Color(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, opacity: 1)
                    ]),
                startPoint: .top,
                endPoint: .bottom
            )
        case .facultyOfInformatics:
            return LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, opacity: 1),
                        Color(red: 0.2854045624, green: 0.4267300284, blue: 0.6992385787, opacity: 1)
                    ]),
                startPoint: .top,
                endPoint: .bottom
            )
        case .facultyOfAccounting:
            return LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, opacity: 1),
                        Color(red: 0.1596036421, green: 0, blue: 0.5802268401, opacity: 1)
                    ]),
                startPoint: .top,
                endPoint: .bottom
            )
        case .facultyOfManagement:
            return LinearGradient(
                gradient: Gradient(
                    colors: [Color(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, opacity: 1),
                             Color(red: 0.09019608051, green: 0, blue: 0.3019607961, opacity: 1)
                            ]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}
