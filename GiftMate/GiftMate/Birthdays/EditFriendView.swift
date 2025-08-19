//
//  EditFriendView.swift
//  GiftMate
//
//  Created by D K on 11.08.2025.
//

import SwiftUI
import RealmSwift

struct EditFriendView: View {
    @ObservedRealmObject var friend: FriendObject
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String
    @State private var birthday: Date
    @State private var interests: String
    @State private var hasBirthday: Bool
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    
    init(friend: FriendObject) {
        self.friend = friend
        _name = State(initialValue: friend.name)
        _birthday = State(initialValue: friend.birthday ?? Date())
        _interests = State(initialValue: friend.interests ?? "")
        _hasBirthday = State(initialValue: friend.birthday != nil)
        if let data = friend.photoData {
            _selectedImage = State(initialValue: UIImage(data: data))
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Button(action: { isImagePickerPresented = true }) {
                            Image(uiImage: selectedImage ?? UIImage(systemName: "person.crop.circle.badge.plus")!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .foregroundColor(.themeSecondaryText)
                        }
                        VStack(alignment: .leading) {
                            Text("Change Photo")
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
            .navigationTitle("Edit Friend")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        StorageManager.shared.updateFriend( // <--- ИЗМЕНЕНИЕ
                            friend._id, // <--- ИЗМЕНЕНИЕ
                            name: name,
                            photoData: selectedImage?.jpegData(compressionQuality: 0.8),
                            birthday: hasBirthday ? birthday : nil,
                            interests: interests
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
