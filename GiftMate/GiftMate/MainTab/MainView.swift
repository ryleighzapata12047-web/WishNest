//
//  MainView.swift
//  GiftMate
//
//  Created by D K on 11.08.2025.
//

import SwiftUI


enum Tab: Int {
    case wishlist, friends, ai, birthdays
}

struct MainView: View {
    
    @State private var selectedTab: Tab = .wishlist
    @State private var isonboardingShown: Bool = false
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.themeBackground.ignoresSafeArea()
                
                switch selectedTab {
                case .wishlist:
                    WishlistCategoriesView()
                case .friends:
                    FriendsView()
                case .ai:
                    AIView()
                case .birthdays:
                    BirthdaysView()
                }
                
                VStack {
                    Spacer()
                    
                    CustomTabBar(selectedTab: $selectedTab)
                        .ignoresSafeArea()
                }
            }
        }
        .customBackground(.themeBackground)
        .ignoresSafeArea(.keyboard)
        .applyTint(.themeAccentYellow)
        .onAppear {
            if !UserDefaults.standard.bool(forKey: "isOnboardingShown") {
                isonboardingShown = true
            }
        }
        .fullScreenCover(isPresented: $isonboardingShown) {
            OnboardingViewV2()
        }
    }
}

private struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack {
            TabItem(iconName: "wand.and.stars", title: "Wishlist", tab: .wishlist, selectedTab: $selectedTab)
            TabItem(iconName: "person.2.fill", title: "Friends", tab: .friends, selectedTab: $selectedTab)
            TabItem(iconName: "sparkles", title: "AI Ideas", tab: .ai, selectedTab: $selectedTab)
            TabItem(iconName: "gift.fill", title: "Birthdays", tab: .birthdays, selectedTab: $selectedTab)
        }
        .padding(.bottom, size().height > 667 ? 20 : 0)
        .frame(height: size().height > 667 ? 100 : 70)
        .background(Color.themeCardBackground)
        .offset(y: size().height > 667 ? 40 : 0)
    }
}

private struct TabItem: View {
    let iconName: String
    let title: String
    let tab: Tab
    @Binding var selectedTab: Tab
    
    var isSelected: Bool {
        selectedTab == tab
    }
    
    var body: some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack(spacing: 4) {
                Image(systemName: iconName)
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? .themeAccentYellow : .themeSecondaryText)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(isSelected ? .themeAccentYellow : .themeSecondaryText)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
