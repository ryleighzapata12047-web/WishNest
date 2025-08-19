//
//  FriendsView.swift
//  GiftMate
//
//  Created by D K on 11.08.2025.
//

import SwiftUI
import RealmSwift

struct FriendsView: View {
    @StateObject private var viewModel = FriendsViewModel()
    
    var body: some View {
            ZStack {
                Color.themeBackground.ignoresSafeArea()
                
                if let friends = viewModel.friends, !friends.isEmpty {
                    
                    ScrollView {
                        VStack {
                            ForEach(friends) { friend in
                                NavigationLink(destination: FriendDetailView(friend: friend)) {
                                    FriendCell(friend: friend)
                                    
                                }
                            }
                        }
                    }
                } else {
                    EmptyStateView(
                        title: "No Friends Yet",
                        message: "Add your friends to start organizing gift ideas for them.",
                        buttonTitle: "Add Your First Friend"
                    ) {
                        viewModel.isShowingAddFriendSheet = true
                    }
                }
            }
            .navigationTitle("Friends & Gifts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.isShowingAddFriendSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
        
        .accentColor(.themeAccentYellow)
        .sheet(isPresented: $viewModel.isShowingAddFriendSheet) {
            AddFriendView()
        }
    }
}

private struct FriendCell: View {
    @ObservedRealmObject var friend: FriendObject
    
    var body: some View {
        HStack(spacing: 16) {
            if let data = friend.photoData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable().scaledToFill()
                    .frame(width: 60, height: 60).clipped().cornerRadius(30)
            } else {
                Image(systemName: "person.fill")
                    .font(.title)
                    .foregroundColor(.themeSecondaryText)
                    .frame(width: 60, height: 60)
                    .background(Color.themeCardBackground.opacity(0.5))
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading) {
                Text(friend.name)
                    .font(.headline)
                    .foregroundColor(.themePrimaryText)
                if let birthday = friend.birthday {
                            Text("Birthday: \(birthday.formatted(dateStyle: .medium, timeStyle: .none))")
                                .font(.subheadline)
                                .foregroundColor(.themeSecondaryText)
                        }
            }
            Spacer()
        }
        .padding()
        .customBackground(.themeCardBackground)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

extension Date {
    func formatted(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
    }
}
