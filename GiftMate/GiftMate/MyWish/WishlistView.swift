//
//  WishlistView.swift
//  GiftMate
//
//  Created by D K on 11.08.2025.
//

import SwiftUI
import RealmSwift

struct WishlistView: View {
    @ObservedRealmObject var category: WishlistCategoryObject
    @ObservedObject var viewModel: WishlistViewModel
    
    var body: some View {
        ZStack {
            Color.themeBackground.ignoresSafeArea()
            
            if category.items.isEmpty {
                EmptyStateView(
                    title: "No Wishes Yet",
                    message: "Tap the '+' button to add your first wish to this category.",
                    buttonTitle: "Add First Wish"
                ) {
                    viewModel.itemToEdit = nil
                    viewModel.isShowingAddItem = true
                }
            } else {
                
                ScrollView {
                    VStack {
                        ForEach(category.items) { item in
                            WishlistItemCell(item: item, viewModel: viewModel)
                                .onTapGesture {
                                    viewModel.selectedItemDetail = item
                                }
                        }
                        
                    }
                    .padding(.bottom, 150)
                }
            }
        }
        .applyTint(.themeAccentYellow)
        .navigationTitle(category.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(action: shareCategory) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    Button(action: {
                        viewModel.itemToEdit = nil
                        viewModel.isShowingAddItem = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .fullScreenCover(item: $viewModel.selectedItemDetail) { item in
            WishItemDetailView(
                item: item,
                viewModel: viewModel,
                category: category,
                onShare: { shareItem(item) },
                onTogglePurchased: {
                    viewModel.markItemAsPurchased(item)
                    viewModel.selectedItemDetail = nil
                }
            )
        }
        .sheet(isPresented: $viewModel.isShowingAddItem) {
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
    
    private func shareCategory() {
        var textToShare = "My Wishlist: \(category.name)\n\n"
        for item in category.items {
            textToShare += "- \(item.name)"
            if let price = item.price, !price.isEmpty { textToShare += " (\(price))" }
            textToShare += "\n"
        }
        
        let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }
    
    private func shareItem(_ item: WishlistItemObject) {
        viewModel.selectedItemDetail = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            var textToShare = "Check out what I want: \(item.name)"
            if let url = item.url, !url.isEmpty { textToShare += "\n\n\(url)" }
            
            let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
            }
        }
    }
}

private struct WishlistItemCell: View {
    @ObservedRealmObject var item: WishlistItemObject
    @ObservedObject var viewModel: WishlistViewModel
    
    var body: some View {
        
        HStack(spacing: 16) {
            if let data = item.photoData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable().scaledToFill()
                    .frame(width: 50, height: 50).clipped().cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(.themePrimaryText)
                    .strikethrough(item.isPurchased)
                
                if let price = item.price, !price.isEmpty {
                    Text(price)
                        .font(.subheadline)
                        .foregroundColor(.themeSecondaryText)
                }
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundColor(.themeSecondaryText.opacity(0.5))
        }
        .customBackground(.themeCardBackground)
        .padding()
        .background(Color.themeCardBackground)
        .cornerRadius(16)
        .padding(.horizontal)
        .contextMenu {
            Button {
                viewModel.deleteItem(item)
            } label: {
                Text("Delete")
            }
        }
    }
}
