//
//  WishlistCategoriesView.swift
//  GiftMate
//
//  Created by D K on 11.08.2025.
//

import SwiftUI
import RealmSwift

struct WishlistCategoriesView: View {
    @StateObject private var viewModel = WishlistViewModel()
    
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
       // NavigationView {
            ZStack {
                Color.themeBackground.ignoresSafeArea()
                
                if let categories = viewModel.categories, !categories.isEmpty {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(categories) { category in
                                NavigationLink(destination: WishlistView(category: category, viewModel: viewModel)) {
                                    CategoryCell(category: category)
                                }
                                .contextMenu {
                                    Button {
                                        viewModel.categoryToEdit = category
                                        viewModel.isShowingAddCategorySheet = true
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    Button {
                                        viewModel.deleteCategory(category)
                                        
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                        
                                    }
                                }
                            }
                        }
                        .padding()
                        .padding(.bottom, 150)
                    }
                } else {
                    EmptyStateView(
                        title: "No Categories Yet",
                        message: "Create categories like 'Gadgets' or 'Travel' to organize your wishlist.",
                        buttonTitle: "Add First Category"
                    ) {
                        viewModel.isShowingAddCategorySheet = true
                    }
                }
            }
            .navigationTitle("My Wishlist")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.isShowingAddCategorySheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
       // }
        .accentColor(.themeAccentYellow)
        .sheet(isPresented: $viewModel.isShowingAddCategorySheet) {
            AddCategoryView(
                categoryToEdit: viewModel.categoryToEdit,
                onSave: { name, iconName in // <--- ИЗМЕНИТЕ
                    if let category = viewModel.categoryToEdit {
                        viewModel.updateCategory(category, newName: name, newIconName: iconName) // <--- ИЗМЕНИТЕ
                    } else {
                        viewModel.addCategory(name: name, iconName: iconName) // <--- ИЗМЕНИТЕ
                    }
                    viewModel.categoryToEdit = nil
                }
            )
        }
    }
}

private struct CategoryCell: View {
    @ObservedRealmObject var category: WishlistCategoryObject
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: category.iconName) 
                .font(.title)
                .foregroundColor(.themeAccentYellow)
            
            Text(category.name)
                .font(.title3).bold()
            
            Spacer()
            
            HStack {
                Text("\(category.items.count) items")
                Spacer()
                Image(systemName: "arrow.right.circle.fill")
            }
            .font(.caption)
            .foregroundColor(.themeSecondaryText)
        }
        .padding()
        .frame(height: 120)
        .background(Color.themeCardBackground)
        .cornerRadius(20)
        .foregroundColor(.themePrimaryText)
    }
}


#Preview {
    WishlistCategoriesView()
}
