//
//  AddGiftIdeaView.swift
//  GiftMate
//
//  Created by D K on 11.08.2025.
//

import SwiftUI
import RealmSwift

struct AddGiftIdeaView: View {
    @ObservedRealmObject var friend: FriendObject
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var price: String = ""
    @State private var url: String = ""
    @State private var tags: String = ""
    
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    
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
                            Text("Add Photo").foregroundColor(.themePrimaryText)
                        }
                    }
                }
                
                Section(header: Text("Gift Idea")) {
                    TextField("Name (e.g., Concert Tickets)", text: $name)
                    TextField("Description (Optional)", text: $description)
                }
                Section(header: Text("Additional Info")) {
                    TextField("Price (Optional)", text: $price)
                    TextField("Link (Optional)", text: $url)
                    TextField("Tags (comma separated)", text: $tags)
                }
            }
            .navigationTitle("New Idea for \(friend.name)")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let tagArray = tags.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                        StorageManager.shared.addGiftIdea(
                            to: friend._id,
                            name: name,
                            description: description,
                            price: price,
                            url: url,
                            photoData: selectedImage?.jpegData(compressionQuality: 0.8),
                            tags: tagArray
                        )
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
