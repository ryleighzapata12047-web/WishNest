//
//  WishlistViewModel.swift
//  GiftMate
//
//  Created by D K on 11.08.2025.
//

import Foundation
import RealmSwift
import Combine

@MainActor
class WishlistViewModel: ObservableObject {
    @Published var categories: Results<WishlistCategoryObject>?
    @Published var selectedCategory: WishlistCategoryObject?
    
    @Published var isShowingAddCategorySheet = false
    @Published var isShowingAddItemSheet = false
    @Published var isShowingAddItem = false

    @Published var categoryToEdit: WishlistCategoryObject?
    
    @Published var itemToEdit: WishlistItemObject?
        @Published var selectedItemDetail: WishlistItemObject?
    
    private var categoriesToken: NotificationToken?
    
    init() {
        setupObserver()
        addBaseCategoriesIfNeeded()
    }
    
    deinit {
        categoriesToken?.invalidate()
    }
    
    
    private let baseCategories: [WishlistCategoryObject] = [
           WishlistViewModel.createBaseCategory(name: "Gadgets", iconName: "iphone"),
           WishlistViewModel.createBaseCategory(name: "Travel", iconName: "airplane"),
           WishlistViewModel.createBaseCategory(name: "Experiences", iconName: "sparkles"),
           WishlistViewModel.createBaseCategory(name: "Clothes", iconName: "tshirt.fill")
       ]    
    
    
    func updateCategory(_ category: WishlistCategoryObject, newName: String, newIconName: String) {
          StorageManager.shared.updateCategory(categoryID: category._id, newName: newName, newIconName: newIconName)
      }
      
      func deleteCategory(_ category: WishlistCategoryObject) {
          StorageManager.shared.deleteCategory(categoryID: category._id)
      }
      
      func addItem(to category: WishlistCategoryObject, name: String, description: String?, price: String?, url: String?, photoData: Data?) {
          StorageManager.shared.addWishlistItem(to: category._id, name: name, description: description, price: price, url: url, photoData: photoData)
      }
      
      func editItem(_ item: WishlistItemObject, name: String, description: String?, price: String?, url: String?, photoData: Data?) {
          StorageManager.shared.updateWishlistItem(item._id, name: name, description: description, price: price, url: url, photoData: photoData)
      }
      
      func markItemAsPurchased(_ item: WishlistItemObject) {
          StorageManager.shared.moveWishlistItemToPurchased(item._id)
      }
      
      func deleteItem(_ item: WishlistItemObject) {
          StorageManager.shared.deleteWishlistItem(item._id)
      }
    
    private func addBaseCategoriesIfNeeded() {
        let realm = try! Realm()
        if realm.objects(WishlistCategoryObject.self).isEmpty {
            try! realm.write {
                realm.add(baseCategories)
            }
        }
    }
    
    private func createBaseCategory(name: String, iconName: String) -> WishlistCategoryObject {
        let category = WishlistCategoryObject()
        category.name = name
        category.iconName = iconName
        return category
    }
    
    private func setupObserver() {
        categories = StorageManager.shared.fetchCategories()
        categoriesToken = categories?.observe { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
    
    func addCategory(name: String, iconName: String) { // <--- ИЗМЕНИТЕ
        StorageManager.shared.addCategory(name: name, iconName: iconName)
    }
}

private extension WishlistViewModel {
    static func createBaseCategory(name: String, iconName: String) -> WishlistCategoryObject {
        let category = WishlistCategoryObject()
        category.name = name
        category.iconName = iconName
        return category
    }
}
