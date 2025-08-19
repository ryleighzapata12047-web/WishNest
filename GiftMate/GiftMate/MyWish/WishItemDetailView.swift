//
//  WishItemDetailView.swift
//  GiftMate
//
//  Created by D K on 11.08.2025.
//

import SwiftUI
import RealmSwift


struct WishItemDetailView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedRealmObject var item: WishlistItemObject
    @ObservedObject var viewModel: WishlistViewModel
    @ObservedRealmObject var category: WishlistCategoryObject
    
    let onShare: () -> Void
    let onTogglePurchased: () -> Void
    
    var body: some View {
        ZStack {
            Color.themeCardBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                HeaderView(
                    onDismiss: { presentationMode.wrappedValue.dismiss() },
                    onEdit: {
                        viewModel.itemToEdit = item
                        viewModel.isShowingAddItemSheet = true
                    }
                )
                
                ScrollView {
                    VStack(spacing: 24) {
                        if let data = item.photoData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable().scaledToFit().cornerRadius(20)
                        }
                        
                        Text(item.name)
                            .font(.largeTitle).bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        InfoSection(item: item)
                    }
                    .padding()
                }
                
                FooterButtons(
                    isPurchased: item.isPurchased,
                    onShare: onShare,
                    onTogglePurchased: onTogglePurchased
                )
            }
        }
        .foregroundColor(.themePrimaryText)
        .sheet(isPresented: $viewModel.isShowingAddItemSheet) {
            AddItemView(
                category: category,
                itemToEdit: viewModel.itemToEdit,
                onSave: { name, desc, price, url, photoData in
                    if let item = viewModel.itemToEdit {
                        viewModel.editItem(item, name: name, description: desc, price: price, url: url, photoData: photoData)
                    } else {
                        viewModel.addItem(to: category, name: name, description: desc, price: price, url: url, photoData: photoData)
                    }
                }
            )
        }
    }
}

private struct HeaderView: View {
    let onDismiss: () -> Void
    let onEdit: () -> Void
    var body: some View {
        HStack {
            Text("Details")
                .font(.largeTitle).bold()
            Spacer()
            Button(action: onEdit) {
                Image(systemName: "pencil").font(.title2)
            }
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.themePrimaryText)
                    .padding(12)
                    .background(Color.black.opacity(0.2))
                    .clipShape(Circle())
            }
        }
        .padding()
    }
}

private struct InfoSection: View {
    @ObservedRealmObject var item: WishlistItemObject
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let desc = item.itemDescription, !desc.isEmpty {
                InfoRow(icon: "text.alignleft", title: "Description", content: desc)
            }
            if let price = item.price, !price.isEmpty {
                InfoRow(icon: "dollarsign.circle.fill", title: "Price", content: price)
            }
            if let urlString = item.url, !urlString.isEmpty, let url = URL(string: urlString) {
                Link(destination: url) {
                    InfoRow(icon: "link", title: "Link", content: urlString, isLink: true)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct InfoRow: View {
    let icon: String
    let title: String
    let content: String
    var isLink: Bool = false
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundColor(.themeSecondaryText)
                .frame(width: 24)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.themeSecondaryText)
                Text(content)
                    .font(.body)
                    .foregroundColor(isLink ? .blue : .themePrimaryText)
            }
        }
    }
}

private struct FooterButtons: View {
    let isPurchased: Bool
    let onShare: () -> Void
    let onTogglePurchased: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            if !isPurchased {
                Button(action: onTogglePurchased) {
                    Label("Mark as Purchased", systemImage: "checkmark")
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            
            Button(action: onShare) {
                Label("Share this Wish", systemImage: "square.and.arrow.up")
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .padding()
        .background(Color.themeCardBackground.ignoresSafeArea(.all, edges: .bottom))
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.bold())
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.themePlaceholder.opacity(0.5))
            .foregroundColor(.themePrimaryText)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.bold())
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.themeAccentYellow)
            .foregroundColor(.themeBackground)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
