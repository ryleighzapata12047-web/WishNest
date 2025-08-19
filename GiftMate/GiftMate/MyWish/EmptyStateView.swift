//
//  EmptyStateView.swift
//  GiftMate
//
//  Created by D K on 11.08.2025.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let message: String
    let buttonTitle: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Text(title).font(.title2).bold()
            Text(message).multilineTextAlignment(.center).foregroundColor(.themeSecondaryText)
            Button(action: action) {
                Text(buttonTitle)
                    .font(.headline.bold())
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.themeAccentYellow)
                    .foregroundColor(.themeBackground)
                    .clipShape(Capsule())
            }
            .padding(.top)
            Spacer()
        }
        .padding(40)
        .foregroundColor(.themePrimaryText)
    }
}
