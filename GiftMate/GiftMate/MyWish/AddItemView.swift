//
//  AddItemView.swift
//  GiftMate
//
//  Created by D K on 11.08.2025.
//

import SwiftUI
import RealmSwift

struct AddItemView: View {
    @ObservedRealmObject var category: WishlistCategoryObject
    @Environment(\.presentationMode) var presentationMode
    
    let itemToEdit: WishlistItemObject?
    let onSave: (String, String?, String?, String?, Data?) -> Void
    
    @State private var name: String
    @State private var itemDescription: String
    @State private var price: String
    @State private var url: String
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    
    init(category: WishlistCategoryObject, itemToEdit: WishlistItemObject? = nil, onSave: @escaping (String, String?, String?, String?, Data?) -> Void) {
        self.category = category
        self.itemToEdit = itemToEdit
        self.onSave = onSave
        
        _name = State(initialValue: itemToEdit?.name ?? "")
        _itemDescription = State(initialValue: itemToEdit?.itemDescription ?? "")
        _price = State(initialValue: itemToEdit?.price ?? "")
        _url = State(initialValue: itemToEdit?.url ?? "")
        if let data = itemToEdit?.photoData {
            _selectedImage = State(initialValue: UIImage(data: data))
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button(action: { isImagePickerPresented = true }) {
                        HStack {
                            if let image = selectedImage {
                                Image(uiImage: image).resizable().scaledToFill()
                                    .frame(width: 80, height: 80).clipped().cornerRadius(12)
                            } else {
                                Image(systemName: "photo.on.rectangle.angled").font(.largeTitle)
                                    .foregroundColor(.themeSecondaryText)
                                    .frame(width: 80, height: 80)
                                    .background(Color.themeCardBackground.opacity(0.5)).cornerRadius(12)
                            }
                            Text("Add or Change Photo").foregroundColor(.themePrimaryText)
                        }
                    }
                }
                
                Section(header: Text("Wish Details")) {
                    TextField("Name (e.g., New Headphones)", text: $name)
                    TextField("Description (Optional)", text: $itemDescription)
                }
                
                Section(header: Text("Additional Info")) {
                    TextField("Price (Optional)", text: $price).keyboardType(.decimalPad)
                    TextField("Link (Optional)", text: $url).keyboardType(.URL)
                }
            }
            .navigationTitle(itemToEdit == nil ? "Add to \(category.name)" : "Edit Wish")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(name, itemDescription, price, url, selectedImage?.jpegData(compressionQuality: 0.8))
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
}
