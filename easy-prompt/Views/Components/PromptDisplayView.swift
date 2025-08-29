//
//  PromptDisplayView.swift
//  easy-prompt
//
//  Created by Macbook on 22.08.2025.
//

import SwiftUI

// MARK: - Prompt Display View
struct PromptDisplayView: View {
    let title: String
    let jsonContent: String
    let onCopy: () -> Void
    @State private var showCopied = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ScrollView {
                Text(jsonContent)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
            }
            
            Button(action: {
                onCopy()
                showCopied = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showCopied = false
                }
            }) {
                HStack {
                    Image(systemName: showCopied ? "checkmark" : "doc.on.doc")
                    Text(showCopied ? "Copied!" : "Copy Prompt")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(showCopied ? Color.green : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
    }
}