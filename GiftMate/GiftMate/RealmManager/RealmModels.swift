//
//  RealmModels.swift
//  GiftMate
//
//  Created by D K on 11.08.2025.
//

import Foundation
import RealmSwift

class WishlistCategoryObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var iconName: String // <--- ДОБАВЬТЕ ЭТО
    @Persisted var items: List<WishlistItemObject>
    @Persisted var createdAt: Date = Date()
}

class WishlistItemObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var itemDescription: String?
    @Persisted var price: String?
    @Persisted var url: String?
    @Persisted var photoData: Data?
    @Persisted var isPurchased: Bool = false
    @Persisted(originProperty: "items") var category: LinkingObjects<WishlistCategoryObject>
}

class FriendObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var photoData: Data?
    @Persisted var birthday: Date?
    @Persisted var interests: String?
    @Persisted var giftIdeas: List<GiftIdeaObject>
}

class GiftIdeaObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var ideaDescription: String?
    @Persisted var price: String?
    @Persisted var url: String?
    @Persisted var photoData: Data?
    @Persisted var tags: List<String>
    @Persisted(originProperty: "giftIdeas") var friend: LinkingObjects<FriendObject>
}
