//
//  FriendsViewModel.swift
//  GiftMate
//
//  Created by D K on 11.08.2025.
//

import Foundation
import RealmSwift
import Combine

@MainActor
class FriendsViewModel: ObservableObject {
    @Published var friends: Results<FriendObject>?
    @Published var isShowingAddFriendSheet = false
    
    private var friendsToken: NotificationToken?
    
    init() {
        setupObserver()
    }
    
    deinit {
        friendsToken?.invalidate()
    }
    
    private func setupObserver() {
        friends = StorageManager.shared.fetchFriends()
        friendsToken = friends?.observe { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
    
    func deleteFriend(at offsets: IndexSet) {
        guard let friends = friends else { return }
        let friendsToDelete = offsets.map { friends[$0] }
        for friend in friendsToDelete {
            StorageManager.shared.deleteFriend(friend)
        }
    }
}
