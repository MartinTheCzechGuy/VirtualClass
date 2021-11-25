//
//  AppTextField.swift
//
//
//  Created by Martin on 11.11.2021.
//

import SwiftUI

public enum TextFieldType {
    case text
    case numeric
    case secure
    
    var isNumeric: Bool { if case .numeric = self { return true }; return false }
    var isSecure: Bool { if case .secure = self { return true }; return false }
}

public struct AppTextField: View {
    
    var imageSystemName: String
    var title: String
    var fieldType: TextFieldType
    @Binding var value: String
    
    public init(
        imageSystemName: String,
        title: String,
        fieldType: TextFieldType,
        value: Binding<String>
    ) {
        self.imageSystemName = imageSystemName
        self.title = title
        self.fieldType = fieldType
        self._value = value
    }
    
    public var body: some View {
        HStack {
            Image(systemName: imageSystemName)
                .font(.system(size: 22))
                .foregroundColor(.gray)
                .frame(width: 35)
            
            ZStack(alignment: .leading) {
                if value.isEmpty {
                    Text(title)
                }
                
                if fieldType.isSecure {
                    SecureField("", text: $value)
                        .autocapitalization(.none)
                } else {
                    TextField("", text: $value)
                        .keyboardType(fieldType.isNumeric ? .numberPad : .default)
                        .autocapitalization(.none)
                }
            }
            .foregroundColor(.black)
            .disableAutocorrection(true)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color.white.opacity(0.7))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}

struct AppTextField_Previews: PreviewProvider {
    @Namespace static var animation
    
    static var previews: some View {
        AppTextField(
            imageSystemName: "person",
            title: "Title",
            fieldType: .text,
            value: .init(get: { return "value" }, set: { _, _ in return })
        )
    }
}
