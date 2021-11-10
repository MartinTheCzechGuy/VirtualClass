//
//  LoginView.swift
//  
//
//  Created by Martin on 10.11.2021.
//

import SwiftUI

public struct LoginView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    
    public init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Text("Hello, World! Iam Login")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: .init())
    }
}
