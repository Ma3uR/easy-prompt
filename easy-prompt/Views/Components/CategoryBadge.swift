//
//  CategoryBadge.swift
//  easy-prompt
//
//  Created by Macbook on 22.08.2025.
//

import SwiftUI

struct CategoryBadge: View {
    let category: ContentCategory
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: category.icon)
                .font(.caption)
            Text(category.rawValue)
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(category.color).opacity(0.2))
        .foregroundColor(Color(category.color))
        .cornerRadius(12)
    }
}