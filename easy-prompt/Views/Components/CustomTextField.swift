//
//  CustomTextField.swift
//  easy-prompt
//
//  Created by Macbook on 22.08.2025.
//

import SwiftUI

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var focused: FocusState<InputView.Field?>.Binding
    let field: InputView.Field
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(.roundedBorder)
                .focused(focused, equals: field)
                .submitLabel(.next)
                .onSubmit {
                    switch field {
                    case .businessType:
                        focused.wrappedValue = .targetAudience
                    case .targetAudience:
                        focused.wrappedValue = .contentGoal
                    case .contentGoal:
                        focused.wrappedValue = nil
                    }
                }
        }
    }
}