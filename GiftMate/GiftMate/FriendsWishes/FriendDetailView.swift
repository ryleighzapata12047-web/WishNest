//
//  FriendDetailView.swift
//  GiftMate
//
//  Created by D K on 11.08.2025.
//

import SwiftUI
import RealmSwift


struct FriendDetailView: View {
    @ObservedRealmObject var friend: FriendObject
    @State private var isShowingAddGiftSheet = false
    @State private var selectedGiftIdea: GiftIdeaObject?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.themeBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Gift Ideas").font(.title2).bold().padding(.horizontal)
                    
                    if friend.giftIdeas.isEmpty {
                        Text("No gift ideas yet. Add one!").foregroundColor(.themeSecondaryText)
                            .frame(maxWidth: .infinity).padding()
                    } else {
                        ForEach(friend.giftIdeas) { idea in
                            GiftIdeaCell(idea: idea)
                                .onTapGesture {
                                    selectedGiftIdea = idea
                                }
                        }
                    }
                }
            }
        }
        .navigationTitle(friend.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(action: { isShowingAddGiftSheet = true }) { Image(systemName: "plus") }
                }
            }
        }
        .sheet(isPresented: $isShowingAddGiftSheet) {
            AddGiftIdeaView(friend: friend)
        }
        .fullScreenCover(item: $selectedGiftIdea) { idea in
            GiftIdeaDetailView(idea: idea) {
                shareItem(idea)
            }
        }
    }
}

private func shareItem(_ item: GiftIdeaObject) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        var textToShare = "Check out what my friend want: \(item.name)"
        if let url = item.url, !url.isEmpty { textToShare += "\n\n\(url)" }
        
        let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }
}

private struct GiftIdeaCell: View {
    @ObservedRealmObject var idea: GiftIdeaObject
    
    var body: some View {
        HStack(spacing: 16) {
            if let data = idea.photoData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable().scaledToFill()
                    .frame(width: 60, height: 60).clipped().cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(idea.name).font(.headline)
                if let desc = idea.ideaDescription, !desc.isEmpty {
                    Text(desc).font(.subheadline).foregroundColor(.themeSecondaryText)
                }
                if !idea.tags.isEmpty {
                    HStack {
                        ForEach(idea.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption).padding(.horizontal, 8).padding(.vertical, 4)
                                .background(Color.themeAccentGreen.opacity(0.3)).cornerRadius(8)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.themeCardBackground)
        .cornerRadius(20)
        .padding(.horizontal)
    }
}


struct GiftIdeaDetailView: View {
    @ObservedRealmObject var idea: GiftIdeaObject
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isEditing = false
    let onShare: () -> Void
    
    var body: some View {
        ZStack {
            Color.themeCardBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                HeaderView(
                    onDismiss: { presentationMode.wrappedValue.dismiss() },
                    onEdit: { isEditing = true }
                )
                
                ScrollView {
                    VStack(spacing: 24) {
                        if let data = idea.photoData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable().scaledToFit().cornerRadius(20)
                        }
                        
                        Text(idea.name)
                            .font(.largeTitle).bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        InfoSection(idea: idea)
                    }
                    .padding()
                }
                
                FooterButton() {
                    presentationMode.wrappedValue.dismiss()
                    onShare()
                }
            }
        }
        .foregroundColor(.themePrimaryText)
        .sheet(isPresented: $isEditing) {
            if let friend = idea.friend.first {
                EditGiftIdeaView(idea: idea, friend: friend)
            }
        }
    }
}


private struct HeaderView: View {
    let onDismiss: () -> Void
    let onEdit: () -> Void
    var body: some View {
        HStack {
            Text("Gift Idea")
                .font(.largeTitle).bold()
            Spacer()
            Button(action: onEdit) {
                Image(systemName: "pencil").font(.title2)
            }
            Button(action: onDismiss) {
                Image(systemName: "xmark").font(.title2)
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
    @ObservedRealmObject var idea: GiftIdeaObject
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            if let desc = idea.ideaDescription, !desc.isEmpty {
                InfoRow(icon: "text.alignleft", title: "Description", content: desc)
            }
            if let price = idea.price, !price.isEmpty {
                InfoRow(icon: "dollarsign.circle.fill", title: "Price", content: price)
            }
            if let urlString = idea.url, !urlString.isEmpty, let url = URL(string: urlString) {
                Link(destination: url) {
                    InfoRow(icon: "link", title: "Link", content: urlString, isLink: true)
                }
            }
            if !idea.tags.isEmpty {
                VStack(alignment: .leading) {
                    Label("Tags", systemImage: "tag.fill").foregroundColor(.themeSecondaryText)
                    HStack {
                        ForEach(idea.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption).padding(.horizontal, 8).padding(.vertical, 4)
                                .background(Color.themeAccentGreen.opacity(0.3)).cornerRadius(8)
                        }
                    }
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
                .frame(width: 24, alignment: .center)
            
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


private struct FooterButton: View {
    let onShare: () -> Void
    
    var body: some View {
        Button(action: onShare) {
            Label("Share this Idea", systemImage: "square.and.arrow.up")
        }
        .buttonStyle(PrimaryButtonStyle())
        .padding()
    }
}


struct EditGiftIdeaView: View {
    @ObservedRealmObject var idea: GiftIdeaObject
    @ObservedRealmObject var friend: FriendObject
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String
    @State private var description: String
    @State private var price: String
    @State private var url: String
    @State private var tags: String
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    
    init(idea: GiftIdeaObject, friend: FriendObject) {
        self.idea = idea
        self.friend = friend
        _name = State(initialValue: idea.name)
        _description = State(initialValue: idea.ideaDescription ?? "")
        _price = State(initialValue: idea.price ?? "")
        _url = State(initialValue: idea.url ?? "")
        _tags = State(initialValue: idea.tags.joined(separator: ", "))
        if let data = idea.photoData {
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
            .navigationTitle("Edit Idea for \(friend.name)")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let tagArray = tags.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                        StorageManager.shared.updateGiftIdea(
                            idea._id,
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
