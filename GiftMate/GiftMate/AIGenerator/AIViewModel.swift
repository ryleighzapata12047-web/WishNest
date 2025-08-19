//
//  AIViewModel.swift
//  GiftMate
//
//  Created by D K on 11.08.2025.
//

import Foundation

extension String: CustomStringConvertible {
    public var description: String { self }
}

enum AIAgeGroup: String, CaseIterable, Identifiable {
    case child = "Child", teen = "Teenager", adult = "Adult", senior = "Senior"
    var id: String { self.rawValue }
}
enum AIBudget: String, CaseIterable, Identifiable {
    case limited = "Limited", medium = "Medium", high = "High"
    var id: String { self.rawValue }
}

@MainActor
class AIViewModel: ObservableObject {
    @Published var loves: String = ""
    @Published var hobbies: String = ""
    @Published var age: AIAgeGroup = .adult
    @Published var budget: AIBudget = .medium
    @Published var occasion: String = "Birthday"
    
    @Published var isLoading = false
    @Published var generatedIdeas: [GiftIdea]?
    @Published var alertError: String?
 
        
    let occasions = ["Birthday", "Wedding", "New Year", "Anniversary", "Other"]
    
    private let geminiService = GeminiService()
    
    var isGenerateButtonEnabled: Bool {
        !loves.isEmpty || !hobbies.isEmpty
    }
    
    func generateIdeas() {
        guard isGenerateButtonEnabled else { return }
        isLoading = true
        
        Task {
            let result = await geminiService.generateGiftIdeas(
                loves: loves, hobbies: hobbies, age: age, budget: budget, occasion: occasion
            )
            
            isLoading = false
            
            switch result {
            case .success(let ideas):
                generatedIdeas = ideas
            case .failure(let error):
                alertError = error.localizedDescription
            }
        }
    }
}
