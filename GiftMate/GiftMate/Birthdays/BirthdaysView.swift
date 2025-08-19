//
//  BirthdaysView.swift
//  GiftMate
//
//  Created by D K on 11.08.2025.
//

import SwiftUI
import RealmSwift


struct BirthdaysView: View {
    @StateObject private var viewModel = BirthdaysViewModel()
    @State private var isAddFriendSheetPresented = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.themeBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    if viewModel.friendsWithBirthdays.count == 0 {
                        EmptyStateView(
                            title: "No Friends Yet",
                            message: "Add your friends to start organizing gift ideas for them.",
                            buttonTitle: "Add Your First Friend"
                        ) {
                            isAddFriendSheetPresented.toggle()
                        }
                    } else {
                        if viewModel.isListView {
                            BirthdayListView(viewModel: viewModel)
                                .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
                        } else {
                            CustomCalendarView(viewModel: viewModel)
                                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        }
                    }
                }
            }
            .navigationTitle("Birthdays")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation { viewModel.isListView.toggle() }
                    }) {
                        Image(systemName: viewModel.isListView ? "calendar" : "list.bullet")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isAddFriendSheetPresented = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .accentColor(.themeAccentYellow)
        .sheet(isPresented: $isAddFriendSheetPresented) {
            AddFriendView()
        }
    }
}

private struct CustomCalendarView: View {
    @ObservedObject var viewModel: BirthdaysViewModel
    
    private let daysOfWeek = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    
    var body: some View {
        VStack {
            MonthHeader(viewModel: viewModel)
                .padding(.horizontal)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 15) {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day).font(.caption).foregroundColor(.themeSecondaryText)
                }
                
                ForEach(getDaysInMonth(), id: \.self) { date in
                    if let date = date {
                        DayCell(date: date, viewModel: viewModel)
                            .onTapGesture {
                                viewModel.selectedDate = date
                            }
                    } else {
                        Rectangle().fill(Color.clear)
                    }
                }
            }
            .padding(.horizontal)
            
            VStack {
                if let selectedDate = viewModel.selectedDate, !viewModel.friendsForSelectedDate().isEmpty {
                    SelectedDayFriendsView(viewModel: viewModel)
                        .frame(maxHeight: 120)
                } else {
                    Spacer()
                        .frame(maxHeight: 120)
                }
            }
            .transition(.opacity)
            
            Spacer()
        }
    }
    
    private func getDaysInMonth() -> [Date?] {
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: viewModel.displayDate) else { return [] }
        
        var days: [Date?] = []
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: viewModel.displayDate))!
        let weekdayOfFirstDay = calendar.component(.weekday, from: firstDayOfMonth)
        
        let emptySpaces = (weekdayOfFirstDay - calendar.firstWeekday + 7) % 7
        for _ in 0..<emptySpaces {
            days.append(nil)
        }
        
        for day in range {
            days.append(calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth))
        }
        
        return days
    }
}

private struct SelectedDayFriendsView: View {
    @ObservedObject var viewModel: BirthdaysViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.selectedDate!.formatted(with: "MMMM d"))
                .font(.headline).padding(.top)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.friendsForSelectedDate()) { friend in
                        BirthdayCell(
                            friend: friend,
                            daysUntil: viewModel.daysUntil(birthday: friend.birthday)
                        )
                        .onTapGesture { viewModel.selectedFriend = friend }
                        .padding(4)
                    }
                }
                .padding(.horizontal)
            }
        }
        .sheet(item: $viewModel.selectedFriend) { friend in
            BirthdayDetailView(friend: friend)
        }
    }
}

private struct MonthHeader: View {
    @ObservedObject var viewModel: BirthdaysViewModel
    
    var body: some View {
        HStack {
            Text(viewModel.displayDate.formatted(with: "MMMM yyyy"))
                .font(.title2).bold()
            
            Spacer()
            
            Button(action: { viewModel.changeMonth(by: -1) }) { Image(systemName: "chevron.left") }
            Button(action: { viewModel.changeMonth(by: 1) }) { Image(systemName: "chevron.right") }
        }
        .foregroundColor(.themePrimaryText)
        .padding(.bottom)
    }
}

private struct DayCell: View {
    let date: Date
    @ObservedObject var viewModel: BirthdaysViewModel
    
    private var hasBirthday: Bool {
        viewModel.friendsWithBirthdays.contains {
            guard let birthday = $0.birthday else { return false }
            let cal = Calendar.current
            return cal.component(.month, from: birthday) == cal.component(.month, from: date) &&
                   cal.component(.day, from: birthday) == cal.component(.day, from: date)
        }
    }
    
    private var isSelected: Bool {
        guard let selected = viewModel.selectedDate else { return false }
        return Calendar.current.isDate(date, inSameDayAs: selected)
    }
    
    var body: some View {
        Text("\(Calendar.current.component(.day, from: date))")
            .fontWeight(.medium)
            .frame(width: 40, height: 40)
            .background(
                ZStack {
                    if isSelected {
                        Circle().fill(Color.themeAccentYellow)
                    }
                    if hasBirthday {
                        Circle().stroke(Color.themeAccentYellow, lineWidth: 2)
                    }
                }
            )
            .foregroundColor(isSelected ? .themeBackground : .themePrimaryText)
    }
}


private struct BirthdayCalendarView: View {
    let friends: [FriendObject]
    @State private var selectedDate: Date?
    
    var body: some View {
        VStack {
            let birthdayDates = friends.compactMap { $0.birthday }
            
            DatePicker(
                "",
                selection: .constant(Date()),
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .accentColor(.themeAccentYellow)
            .colorScheme(.dark)
            .padding()
            .background(Color.themeCardBackground)
            .cornerRadius(20)
            .padding()
        }
    }
}
private struct BirthdayListView: View {
    @ObservedObject var viewModel: BirthdaysViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.friendsWithBirthdays) { friend in
                Button(action: { viewModel.selectedFriend = friend }) {
                    BirthdayCell(friend: friend, daysUntil: viewModel.daysUntil(birthday: friend.birthday))
                }
            }
            .listRowBackground(Color.themeBackground)
            .hideListRowSeparator()
        }
        .listStyle(PlainListStyle())
        .sheet(item: $viewModel.selectedFriend) { friend in
            BirthdayDetailView(friend: friend)
        }
    }
}

private struct BirthdayCell: View {
    @ObservedRealmObject var friend: FriendObject
    let daysUntil: Int
    
    var body: some View {
        HStack {
            if let data = friend.photoData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage).resizable().scaledToFill()
                    .frame(width: 50, height: 50).clipped().cornerRadius(25)
            } else {
                Image(systemName: "person.fill").font(.title)
                    .frame(width: 50, height: 50).background(Color.themeCardBackground).clipShape(Circle())
            }
            
            VStack(alignment: .leading) {
                Text(friend.name).font(.headline)
                if let birthday = friend.birthday {
                    Text(birthday.formatted(dateStyle: .medium, timeStyle: .none))
                        .font(.subheadline).foregroundColor(.themeSecondaryText)
                }
            }
            
            Spacer()
            
            VStack {
                Text("\(daysUntil)").font(.title2).bold().foregroundColor(.themeAccentYellow)
                Text("days left").font(.caption).foregroundColor(.themeSecondaryText)
            }
        }
        .padding()
        .background(Color.themeCardBackground)
        .cornerRadius(16)
    }
}

extension Date {
    
    func formatted(with format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
