//
//  AIResultsView.swift
//  GiftMate
//
//  Created by D K on 11.08.2025.
//


import SwiftUI
import RealmSwift


struct AIResultsView: View {
    @Environment(\.presentationMode) var presentationMode
    let ideas: [GiftIdea]
    
    @State private var friendToSaveTo: FriendObject?
    @State private var selectedIdea: GiftIdea?
    @State private var isFriendListPresented = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.themeBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Text("Generated Ideas")
                        .font(.largeTitle).bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    
                    ScrollView {
                        ForEach(ideas) { idea in
                            GiftIdeaCard(idea: idea) {
                                selectedIdea = idea
                                isFriendListPresented = true
                            }
                        }
                    }
                }
                .foregroundColor(.themePrimaryText)
            }
            .navigationBarHidden(true)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { presentationMode.wrappedValue.dismiss() }
                }
            }
            .sheet(isPresented: $isFriendListPresented) {
                FriendSelectionView(onSelect: { friend in
                    if let idea = selectedIdea {
                        StorageManager.shared.addGiftIdea(to: friend._id, name: idea.name, description: idea.description, price: idea.approximatePrice, url: nil, photoData: nil, tags: ["AI Generated"])
                    }
                })
            }
        }
    }
}


private struct GiftIdeaCard: View {
    let idea: GiftIdea
    let onSave: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(idea.name)
                .font(.title3).bold()
            
            Text(idea.description)
                .font(.body)
                .foregroundColor(.themeSecondaryText)
            
            HStack {
                Text(idea.approximatePrice)
                    .font(.subheadline).bold()
                    .foregroundColor(.themeAccentGreen)
                
                Spacer()
                
                Button(action: onSave) {
                    Label("Save for Friend", systemImage: "person.fill.badge.plus")
                        .font(.caption.bold())
                }
                .buttonStyle(SecondaryButtonStyle())
            }
        }
        .padding()
        .background(Color.themeCardBackground)
        .cornerRadius(20)
        .padding(.horizontal)
    }
}


struct FriendSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedResults(FriendObject.self) var friends
    let onSelect: (FriendObject) -> Void
    
    var body: some View {
        NavigationView {
            List(friends) { friend in
                Button(action: {
                    onSelect(friend)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text(friend.name)
                }
            }
            .navigationTitle("Select a Friend")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                }
            }
        }
    }
}


extension Array: Identifiable where Element: Hashable {
    public var id: Int { self.hashValue }
}
