//
//  AIView.swift
//  GiftMate
//
//  Created by D K on 11.08.2025.
//

import SwiftUI

struct AIView: View {
    @StateObject private var viewModel = AIViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.themeBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 32) {
                            Text("Gift Idea Generator")
                                .font(.largeTitle).bold()
                                .padding(.bottom, 8)
                            
                            FormSection(title: "Who is this for?") {
                                CustomTextField(placeholder: "Loves (e.g., coffee, dogs, travel)", text: $viewModel.loves)
                                CustomTextField(placeholder: "Hobbies (e.g., hiking, reading)", text: $viewModel.hobbies)
                            }
                            
                            FormSection(title: "Details") {
                                CustomPicker(title: "Age Group", selection: $viewModel.age)
                                StringPicker(title: "Occasion", options: viewModel.occasions, selection: $viewModel.occasion)
                            }
                            
                            FormSection(title: "Budget") {
                                BudgetPicker(selection: $viewModel.budget)
                            }
                            
                            Button(action: viewModel.generateIdeas) {
                                if viewModel.isLoading {
                                    ProgressView().applyTint(.themeBackground)
                                } else {
                                    Label("Generate Ideas", systemImage: "sparkles")
                                }
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(!viewModel.isGenerateButtonEnabled || viewModel.isLoading)
                            .padding()
                            .padding(.bottom, 150)
                        }
                        .padding()
                        
                        
                    }
                    
                   
                }
            }
            .navigationBarHidden(true)
            .sheet(item: $viewModel.generatedIdeas) { ideas in
                AIResultsView(ideas: ideas)
            }
            .compatibilityAlert("Error", isPresented: .constant(viewModel.alertError != nil), actions: {
                Button("OK") { viewModel.alertError = nil }
            }, message: {
                Text(viewModel.alertError ?? "An unknown error occurred.")
            })
        }
    }
}


private struct FormSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title).font(.headline).foregroundColor(.themeSecondaryText)
            content
        }
    }
}

private struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.themeCardBackground)
            .cornerRadius(12)
            .foregroundColor(.themePrimaryText)
    }
}

private struct CustomPicker<T: Hashable & CustomStringConvertible>: View where T: CaseIterable, T.AllCases: RandomAccessCollection {
    let title: String
    @Binding var selection: T
    
    var body: some View {
        Picker(title, selection: $selection) {
            ForEach(T.allCases, id: \.self) { value in
                Text(value.description).tag(value)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.themeCardBackground)
        .cornerRadius(12)
        .accentColor(.themeAccentYellow)
    }
}

private struct BudgetPicker: View {
    @Binding var selection: AIBudget
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(AIBudget.allCases) { budget in
                Button(action: { selection = budget }) {
                    Text(budget.rawValue)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selection == budget ? Color.themeAccentYellow.opacity(0.3) : Color.clear)
                        .foregroundColor(selection == budget ? .themeAccentYellow : .themePrimaryText)
                }
                if budget != AIBudget.allCases.last {
                    Divider().frame(width: 1).background(Color.themePlaceholder)
                }
            }
        }
        .frame(height: 50)
        .background(Color.themeCardBackground)
        .cornerRadius(12)
    }
}

extension AIAgeGroup: CustomStringConvertible {
    var description: String { self.rawValue }
}

extension String: Identifiable {
    public var id: String { self }
}

extension AIBudget: CustomStringConvertible {
    var description: String { self.rawValue }
}

extension AIViewModel {
    convenience init(forPreview: Bool) {
        self.init()
        if forPreview {
            self.loves = "Coffee"
            self.hobbies = "Reading"
        }
    }
}

struct AIView_Previews: PreviewProvider {
    static var previews: some View {
        AIView()
            .preferredColorScheme(.dark)
    }
}

private struct StringPicker: View {
    let title: String
    let options: [String]
    @Binding var selection: String
    
    var body: some View {
        Picker(title, selection: $selection) {
            ForEach(options, id: \.self) { value in
                Text(value).tag(value)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.themeCardBackground)
        .cornerRadius(12)
        .accentColor(.themeAccentYellow)
    }
}
