//
//  AddCategoryView.swift
//  GiftMate
//
//  Created by D K on 11.08.2025.
//

import SwiftUI

struct AddCategoryView: View {
    @Environment(\.presentationMode) var presentationMode
    let categoryToEdit: WishlistCategoryObject?
    let onSave: (String, String) -> Void // <--- ИЗМЕНИТЕ
    
    @State private var name: String = ""
    @State private var selectedIcon: String = "gift.fill" // <--- ДОБАВЬТЕ
    
    private let icons = ["gift.fill", "iphone", "airplane", "sparkles", "tshirt.fill", "book.fill", "gamecontroller.fill", "car.fill"]
    private let columns = [GridItem(.adaptive(minimum: 60))]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Category Name")) {
                    TextField("e.g., Gadgets", text: $name)
                }
                
                Section(header: Text("Icon")) {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(icons, id: \.self) { icon in
                            Image(systemName: icon)
                                .font(.title)
                                .frame(width: 60, height: 60)
                                .background(selectedIcon == icon ? Color.themeAccentYellow.opacity(0.3) : Color.themeCardBackground)
                                .cornerRadius(12)
                                .foregroundColor(selectedIcon == icon ? .themeAccentYellow : .themePrimaryText)
                                .onTapGesture { selectedIcon = icon }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle(categoryToEdit == nil ? "New Category" : "Edit Category")
            .onAppear {
                if let category = categoryToEdit {
                    name = category.name
                    selectedIcon = category.iconName
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(name, selectedIcon) // <--- ИЗМЕНИТЕ
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}
