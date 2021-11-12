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
    
    // když View nastavíš .matchedGeometryEffect a dáš mu tohle ID kontenxtu,
    // dokáže systém animovat situace, kdy se mění pozice tohoto View
    var animation: Namespace.ID
    
    public init(
        imageSystemName: String,
        title: String,
        fieldType: TextFieldType,
        value: Binding<String>,
        animation: Namespace.ID
    ) {
        self.imageSystemName = imageSystemName
        self.title = title
        self.fieldType = fieldType
        self._value = value
        self.animation = animation
    }
    
    public var body: some View {
        VStack(spacing: 6) {
            HStack(alignment: .bottom) {
                Image(systemName: imageSystemName)
                    .font(.system(size: 22))
                    .foregroundColor(value == "" ? .gray : .primary)
                    .frame(width: 35)
                
                VStack(alignment: .leading, spacing: 6) {
                    if value != "" {
                        Text(title)
                            .font(.caption)
                            .fontWeight(.heavy)
                            .foregroundColor(.gray)
                            .matchedGeometryEffect(id: title, in: animation)
                    }
                    
                    ZStack(alignment: .init(horizontal: .leading, vertical: .center)) {
                        
                        if value == "" {
                            Text(title)
                                .font(.caption)
                                .fontWeight(.heavy)
                                .foregroundColor(.gray)
                                .matchedGeometryEffect(id: title, in: animation)
                        }
                        
                        if fieldType.isSecure {
                            SecureField("", text: $value)
                        } else {
                            TextField("", text: $value)
                                .keyboardType(fieldType.isNumeric ? .numberPad : .default)
                        }
                    }
                }
            }
            
            if value == "" {
                Divider()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color("AppTextField").opacity(value == "" ? 1 : 0))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(value == "" ? 0 : 0.1), radius: 5, x: 5, y: 5)
        .shadow(color: Color.black.opacity(value == "" ? 0 : 0.05), radius: 5, x: -5, y: -5)
        .padding(.horizontal)
        .padding(.top)
        .animation(.linear)
    }
}

struct AppTextField_Previews: PreviewProvider {
    @Namespace static var animation

    static var previews: some View {
        AppTextField(
            imageSystemName: "person",
            title: "Title",
            fieldType: .text,
            value: .init(get: { return "value" }, set: { _, _ in return }),
            animation: animation
        )
    }
}
