//
//  BirthdayDetailView.swift
//  GiftMate
//
//  Created by D K on 11.08.2025.
//

import SwiftUI
import RealmSwift


struct BirthdayDetailView: View {
    @ObservedRealmObject var friend: FriendObject
    @Environment(\.presentationMode) var presentationMode
    @State private var isEditing = false
    
    var body: some View {
        ZStack {
            Color.themeBackground.ignoresSafeArea()
            
            VStack {
                HeaderView(
                    name: friend.name,
                    onDismiss: { presentationMode.wrappedValue.dismiss() },
                    onEdit: { isEditing = true }
                )
                
                ScrollView {
                    VStack(spacing: 32) {
                        ProfilePhoto(photoData: friend.photoData)
                        
                        if let birthday = friend.birthday {
                            Text(birthday.formatted(dateStyle: .long, timeStyle: .none))
                                .font(.title2)
                                .foregroundColor(.themeSecondaryText)
                        }
                        
                        if let interests = friend.interests, !interests.isEmpty {
                            InfoCard(title: "Notes & Interests", content: interests)
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
               
            }
            .foregroundColor(.themePrimaryText)
        }
        .sheet(isPresented: $isEditing) {
            EditFriendView(friend: friend)
        }
    }
}

private struct HeaderView: View {
    let name: String
    let onDismiss: () -> Void
    let onEdit: () -> Void
    
    var body: some View {
        HStack {
            Text(name).font(.largeTitle).bold()
            Spacer()
            Button(action: onEdit) { Image(systemName: "pencil").font(.title2) }
            Button(action: onDismiss) {
                Image(systemName: "xmark").font(.title2)
                    .padding(12).background(Color.black.opacity(0.2)).clipShape(Circle())
            }
        }
        .padding()
    }
}

private struct ProfilePhoto: View {
    let photoData: Data?
    
    var body: some View {
        Group {
            if let data = photoData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage).resizable().scaledToFill()
            } else {
                Image(systemName: "person.fill").resizable().scaledToFit()
                    .padding(40).foregroundColor(.themeSecondaryText)
                    .background(Color.themeCardBackground.opacity(0.5))
            }
        }
        .frame(width: 150, height: 150).clipShape(Circle())
        .overlay(Circle().stroke(Color.themeAccentYellow, lineWidth: 4))
    }
}

private struct InfoCard: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: "note.text")
                .font(.headline).foregroundColor(.themeSecondaryText)
            Text(content)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.themeCardBackground)
                .cornerRadius(16)
        }
    }
}
