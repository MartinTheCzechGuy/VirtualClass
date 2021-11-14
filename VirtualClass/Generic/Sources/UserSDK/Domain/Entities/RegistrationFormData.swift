//
//  RegistrationFormData.swift
//  
//
//  Created by Martin on 13.11.2021.
//

public struct RegistrationFormData {
    let email: String
    let password1: String
    let password2: String
    let name: String
    
    public init(
        email: String,
        password1: String,
        password2: String,
        name: String
    ) {
        self.email = email
        self.password1 = password1
        self.password2 = password2
        self.name = name
    }
}
