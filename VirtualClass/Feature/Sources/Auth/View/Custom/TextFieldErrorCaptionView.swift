//
//  TextFieldErrorCaptionView.swift
//  
//
//  Created by Martin on 12.11.2021.
//

import SwiftUI

struct TextFieldErrorCaptionView: View {
    
    enum Status {
        case invalidPassword
        case invalidEmail
        case nonMatchingPasswords
        case emailAlreadytaken
        case invalidCredentials
        case errorStoringCredentials
        case unknownEmail
        
        var text: String {
            switch self {
            case .invalidPassword:
                return "The password must be at least 8 characters long containg one number and one Capital leter."
            case .invalidEmail:
                return "Enter a valid email address."
            case .nonMatchingPasswords:
                return "Entered passwords must be the same."
            case .emailAlreadytaken:
                return "Entered email is already taken."
            case .invalidCredentials:
                return "Invalid credentials."
            case .errorStoringCredentials:
                return "Something went wrong. Please try again."
            case .unknownEmail:
                return "Account registered on entered email does not exists."
            }
        }
    }
    
    let status: Status
    
    var body: some View {
        Text(status.text)
            .fixedSize(horizontal: false, vertical: true)
            .font(.caption)
            .foregroundColor(.white)
            .padding()
            .background(Color.red)
            .cornerRadius(16)
    }
}
