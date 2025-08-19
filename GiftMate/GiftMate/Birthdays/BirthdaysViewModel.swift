//
//  BirthdaysViewModel.swift
//  GiftMate
//
//  Created by D K on 11.08.2025.
//

import Foundation
import RealmSwift
import Combine

@MainActor
class BirthdaysViewModel: ObservableObject {
    @Published var friendsWithBirthdays: [FriendObject] = []
    @Published var isListView: Bool = true
    @Published var selectedFriend: FriendObject?
    
    @Published var displayDate: Date = Date()
    @Published var selectedDate: Date?
    
    private var friendsToken: NotificationToken?
    
    init() {
        setupObserver()
    }
    
    deinit {
        friendsToken?.invalidate()
    }
    
    func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: displayDate) {
            displayDate = newDate
        }
    }
    
    func friendsForSelectedDate() -> [FriendObject] {
        guard let selectedDate = selectedDate else { return [] }
        return friendsWithBirthdays.filter {
            guard let birthday = $0.birthday else { return false }
            let cal = Calendar.current
            return cal.component(.month, from: birthday) == cal.component(.month, from: selectedDate) &&
            cal.component(.day, from: birthday) == cal.component(.day, from: selectedDate)
        }
    }
    
    private func setupObserver() {
        let results = StorageManager.shared.fetchFriendsWithBirthdays()
        friendsToken = results.observe { [weak self] _ in
            self?.sortFriendsByNextBirthday()
        }
    }
    
    private func sortFriendsByNextBirthday() {
        let friends = StorageManager.shared.fetchFriendsWithBirthdays()
        let sortedFriends = friends.sorted { friend1, friend2 in
            let nextBirthday1 = nextBirthday(for: friend1.birthday!)
            let nextBirthday2 = nextBirthday(for: friend2.birthday!)
            return nextBirthday1 < nextBirthday2
        }
        self.friendsWithBirthdays = Array(sortedFriends)
    }
    
    private func nextBirthday(for date: Date) -> Date {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.month, .day], from: date)
        var nextBirthdayComponents = DateComponents()
        nextBirthdayComponents.month = components.month
        nextBirthdayComponents.day = components.day
        nextBirthdayComponents.year = calendar.component(.year, from: today)
        
        var nextBirthday = calendar.date(from: nextBirthdayComponents)!
        
        if nextBirthday < today {
            nextBirthdayComponents.year! += 1
            nextBirthday = calendar.date(from: nextBirthdayComponents)!
        }
        return nextBirthday
    }
    
    func daysUntil(birthday: Date?) -> Int {
        guard let birthday = birthday else { return 0 }
        let next = nextBirthday(for: birthday)
        return Calendar.current.dateComponents([.day], from: Date(), to: next).day ?? 0
    }
}
