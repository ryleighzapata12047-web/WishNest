//
//  AddFriendView.swift
//  GiftMate
//
//  Created by D K on 11.08.2025.
//

import SwiftUI

struct AddFriendView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var birthday: Date = Date()
    @State private var interests: String = ""
    @State private var hasBirthday = false
    
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Button(action: { isImagePickerPresented = true }) {
                            if let selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                            } else {
                                Image(uiImage: UIImage(systemName: "person.crop.circle.badge.plus")!)
                                    .resizable()
                                    .renderingMode(.template)
                                    .colorMultiply(.themeSecondaryText)
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                            }
                            
                        }
                        .padding(.trailing)
                        
                        VStack(alignment: .leading) {
                            Text("Add Photo")
                                .font(.headline)
                            Text("(Optional)")
                                .font(.caption)
                                .foregroundColor(.themeSecondaryText)
                        }
                    }
                }
                
                Section(header: Text("Friend's Info")) {
                    TextField("Name", text: $name)
                    Toggle("Set Birthday", isOn: $hasBirthday.animation())
                    if hasBirthday {
                        DatePicker("Birthday", selection: $birthday, displayedComponents: .date)
                    }
                    TextField("Interests (comma separated)", text: $interests)
                }
            }
            .navigationTitle("Add Friend")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        StorageManager.shared.addFriend(
                            name: name,
                            photoData: selectedImage?.jpegData(compressionQuality: 0.8),
                            birthday: hasBirthday ? birthday : nil,
                            interests: interests.isEmpty ? nil : interests
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
