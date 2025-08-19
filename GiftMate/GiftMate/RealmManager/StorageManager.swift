//
//  StorageManager.swift
//  GiftMate
//
//  Created by D K on 11.08.2025.
//

import Foundation
import RealmSwift

final class StorageManager {
    static let shared = StorageManager()
    
    private let realm: Realm
    
    private init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }
    
    private func write(_ block: () -> Void) {
        do { try realm.write { block() } } catch { print("Error writing to Realm: \(error)") }
    }
    
    func updateGiftIdea(_ ideaID: ObjectId, name: String, description: String?, price: String?, url: String?, photoData: Data?, tags: [String]) {
        guard let idea = realm.object(ofType: GiftIdeaObject.self, forPrimaryKey: ideaID) else { return }
        write {
            idea.name = name
            idea.ideaDescription = description
            idea.price = price
            idea.url = url
            idea.photoData = photoData
            idea.tags.removeAll()
            idea.tags.append(objectsIn: tags)
        }
    }

    func deleteGiftIdea(_ ideaID: ObjectId) { // Изменяем, чтобы принимать ID
        guard let idea = realm.object(ofType: GiftIdeaObject.self, forPrimaryKey: ideaID) else { return }
        write { realm.delete(idea) }
    }

    
    func addFriend(name: String, photoData: Data?, birthday: Date?, interests: String?) {
        let friend = FriendObject()
        friend.name = name
        friend.photoData = photoData
        friend.birthday = birthday
        friend.interests = interests
        
        write { realm.add(friend) }
    }
    
    func addGiftIdea(to friendID: ObjectId, name: String, description: String?, price: String?, url: String?, photoData: Data?, tags: [String]) {
        guard let friend = realm.object(ofType: FriendObject.self, forPrimaryKey: friendID) else { return }
        
        let idea = GiftIdeaObject()
        idea.name = name
        idea.ideaDescription = description
        idea.price = price
        idea.url = url
        idea.photoData = photoData
        idea.tags.append(objectsIn: tags)
        
        write { friend.giftIdeas.append(idea) }
    }
    
    // MARK: - Category Methods
    func fetchCategories() -> Results<WishlistCategoryObject> {
        realm.objects(WishlistCategoryObject.self).sorted(byKeyPath: "createdAt")
    }
    
    func addCategory(name: String, iconName: String) {
        let category = WishlistCategoryObject()
        category.name = name
        category.iconName = iconName
        write { realm.add(category) }
    }
    
    func updateCategory(categoryID: ObjectId, newName: String, newIconName: String) {
        guard let category = realm.object(ofType: WishlistCategoryObject.self, forPrimaryKey: categoryID) else { return }
        write {
            category.name = newName
            category.iconName = newIconName
        }
    }
    
    func deleteCategory(categoryID: ObjectId) {
        guard let category = realm.object(ofType: WishlistCategoryObject.self, forPrimaryKey: categoryID) else { return }
        write {
            realm.delete(category.items)
            realm.delete(category)
        }
    }
    
    // MARK: - Wishlist Item Methods
    func addWishlistItem(to categoryID: ObjectId, name: String, description: String?, price: String?, url: String?, photoData: Data?) {
        guard let category = realm.object(ofType: WishlistCategoryObject.self, forPrimaryKey: categoryID) else { return }
        let item = WishlistItemObject()
        item.name = name; item.itemDescription = description; item.price = price; item.url = url; item.photoData = photoData
        write { category.items.append(item) }
    }
    
    func updateWishlistItem(_ itemID: ObjectId, name: String, description: String?, price: String?, url: String?, photoData: Data?) {
        guard let item = realm.object(ofType: WishlistItemObject.self, forPrimaryKey: itemID) else { return }
        write {
            item.name = name; item.itemDescription = description; item.price = price; item.url = url; item.photoData = photoData
        }
    }
    
    func moveWishlistItemToPurchased(_ itemID: ObjectId) {
        guard let item = realm.object(ofType: WishlistItemObject.self, forPrimaryKey: itemID) else { return }
        
        let purchasedCategory = getOrCreatePurchasedCategory()
        
        let newItem = WishlistItemObject()
        newItem.name = item.name
        newItem.itemDescription = item.itemDescription
        newItem.price = item.price
        newItem.url = item.url
        newItem.photoData = item.photoData
        newItem.isPurchased = true
        
        write {
            purchasedCategory.items.append(newItem)
            realm.delete(item)
        }
    }
    
    func deleteWishlistItem(_ itemID: ObjectId) {
        guard let item = realm.object(ofType: WishlistItemObject.self, forPrimaryKey: itemID) else { return }
        write { realm.delete(item) }
    }
    
    private func getOrCreatePurchasedCategory() -> WishlistCategoryObject {
        let purchasedName = "Purchased"
        if let purchasedCategory = realm.objects(WishlistCategoryObject.self).filter("name == %@", purchasedName).first {
            return purchasedCategory
        } else {
            let newCategory = WishlistCategoryObject()
            newCategory.name = purchasedName
            newCategory.iconName = "checkmark.circle.fill"
            newCategory.createdAt = Date.distantFuture
            write { realm.add(newCategory) }
            return newCategory
        }
    }
    
    func updateCategory(category: WishlistCategoryObject, newName: String, newIconName: String) {
        write {
            category.name = newName
            category.iconName = newIconName
        }
    }
    
    func deleteCategory(category: WishlistCategoryObject) {
        write {
            realm.delete(category.items)
            realm.delete(category)
        }
    }
    
    // MARK: - Wishlist Item Methods
    
    
    func updateWishlistItem(_ item: WishlistItemObject, isPurchased: Bool) {
        write { item.isPurchased = isPurchased }
    }
    
    func deleteWishlistItem(_ item: WishlistItemObject) {
        write { realm.delete(item) }
    }
    
    // MARK: - Friend Methods
    
    func fetchFriends() -> Results<FriendObject> {
        realm.objects(FriendObject.self).sorted(byKeyPath: "name")
    }
    
    func deleteFriend(_ friend: FriendObject) {
        write {
            realm.delete(friend.giftIdeas)
            realm.delete(friend)
        }
    }
    
    // MARK: - Gift Idea Methods
    
    
    
    func addGiftIdea(to friend: FriendObject, name: String, description: String?, price: String?, url: String?, tags: [String]) {
        let idea = GiftIdeaObject()
        idea.name = name
        idea.ideaDescription = description
        idea.price = price
        idea.url = url
        idea.tags.append(objectsIn: tags)
        
        write { friend.giftIdeas.append(idea) }
    }
    
    func deleteGiftIdea(_ idea: GiftIdeaObject) {
        write { realm.delete(idea) }
    }
    
    
    func fetchFriendsWithBirthdays() -> Results<FriendObject> {
        realm.objects(FriendObject.self).filter("birthday != nil").sorted(byKeyPath: "name")
    }
    
    func updateWishlistItem(_ item: WishlistItemObject, name: String, description: String?, price: String?, url: String?, photoData: Data?) {
        write {
            item.name = name
            item.itemDescription = description
            item.price = price
            item.url = url
            item.photoData = photoData
        }
    }
    
    func updateFriend(_ friendID: ObjectId, name: String, photoData: Data?, birthday: Date?, interests: String?) {
        guard let friend = realm.object(ofType: FriendObject.self, forPrimaryKey: friendID) else { return }
        write {
            friend.name = name
            friend.photoData = photoData
            friend.birthday = birthday
            friend.interests = interests
        }
    }
}
