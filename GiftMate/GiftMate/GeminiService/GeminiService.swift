//
//  GeminiService.swift
//  GiftMate
//
//  Created by D K on 11.08.2025.
//

import Foundation

struct GiftIdea: Codable, Hashable, Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let approximatePrice: String
    
    enum CodingKeys: String, CodingKey {
        case name, description
        case approximatePrice = "approximate_price"
    }
}

final class GeminiService {
    
    private let apiKey = "AIzaSyDeKZRT21892LO6NjoSWdWgq3OfXeiOG1c"
    private let modelName = "gemini-1.5-flash"
    private lazy var apiURL: URL? = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "generativelanguage.googleapis.com"
        components.path = "/v1beta/models/\(modelName):generateContent"
        components.queryItems = [URLQueryItem(name: "key", value: apiKey)]
        return components.url
    }()

    enum GeminiError: Error, LocalizedError {
        case invalidURL, requestEncodingFailed, networkError(Error)
        case apiError(String), decodingError(Error), noContentGenerated
        
        var errorDescription: String? {
            switch self {
            case .invalidURL: return "The API URL is invalid."
            case .requestEncodingFailed: return "Failed to encode the request."
            case .networkError: return "A network error occurred. Please check your connection."
            case .apiError(let message): return "The API returned an error: \(message)"
            case .decodingError: return "Failed to decode the AI response. Please try again."
            case .noContentGenerated: return "The AI could not generate ideas for this request. Try adjusting the interests."
            }
        }
    }
    
    func generateGiftIdeas(loves: String, hobbies: String, age: AIAgeGroup, budget: AIBudget, occasion: String) async -> Result<[GiftIdea], GeminiError> {
        guard let url = apiURL else { return .failure(.invalidURL) }
        
        let prompt = createPrompt(loves: loves, hobbies: hobbies, age: age, budget: budget, occasion: occasion)
        let requestPayload = GeminiAPIRequest(contents: [Content(parts: [Part(text: prompt)])])
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do { request.httpBody = try JSONEncoder().encode(requestPayload) } catch { return .failure(.requestEncodingFailed) }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return .failure(.apiError("HTTP Status \((response as? HTTPURLResponse)?.statusCode ?? 0)"))
            }
            
            let geminiResponse = try JSONDecoder().decode(GeminiAPIResponse.self, from: data)
            
            guard let textContent = geminiResponse.candidates?.first?.content.parts.first?.text else {
                return .failure(.noContentGenerated)
            }
            
            return parseGiftIdeas(from: textContent)
            
        } catch let error as DecodingError { return .failure(.decodingError(error)) }
          catch { return .failure(.networkError(error)) }
    }
    
    private func createPrompt(loves: String, hobbies: String, age: AIAgeGroup, budget: AIBudget, occasion: String) -> String {
        return """
        You are a highly creative and practical gift recommendation expert. Your ONLY task is to generate a list of 5 unique and thoughtful gift ideas based on the user's input.

        **User's Input:**
        - Loves: "\(loves)"
        - Hobbies: "\(hobbies)"
        - Age Group: "\(age.rawValue)"
        - Budget: "\(budget.rawValue)"
        - Occasion: "\(occasion)"

        **Instructions:**
        1.  Strictly focus on generating gift ideas. Refuse any other type of request.
        2.  Generate exactly 5 distinct ideas.
        3.  For each idea, provide a creative name, a brief but compelling description (20-30 words), and an approximate price range (e.g., "$20-50", "$100+", "Under $30").
        4.  The ideas must be highly relevant to the provided interests, age, budget, and occasion.

        **Output Format:**
        Your response MUST be a single, valid JSON array of objects. Do not include any text, explanations, or markdown formatting like ```json before or after the JSON. Your entire response must be the raw JSON array itself.

        The JSON structure for each object in the array MUST be as follows:
        {
          "name": "string",
          "description": "string",
          "approximate_price": "string"
        }

        **Example of a valid full response:**
        [
          {
            "name": "Artisanal Coffee Subscription",
            "description": "A monthly delivery of unique, high-quality coffee beans from around the world. Perfect for exploring new flavors and elevating their morning routine.",
            "approximate_price": "$50-100"
          },
          {
            "name": "Smart Indoor Garden",
            "description": "An automated, soil-free garden for growing fresh herbs and vegetables indoors. A great gift for tech lovers and home cooks.",
            "approximate_price": "$100+"
          }
        ]
        """
    }
    
    private func parseGiftIdeas(from jsonString: String) -> Result<[GiftIdea], GeminiError> {
        let cleanedString = jsonString.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "```json", with: "").replacingOccurrences(of: "```", with: "")
        
        guard let data = cleanedString.data(using: .utf8) else { return .failure(.decodingError(NSError())) }
        
        do {
            let ideas = try JSONDecoder().decode([GiftIdea].self, from: data)
            return .success(ideas)
        } catch {
            return .failure(.decodingError(error))
        }
    }
}


private extension GeminiService {
    struct GeminiAPIRequest: Encodable { let contents: [Content] }
    struct Content: Encodable { let parts: [Part] }
    struct Part: Encodable { let text: String }
    struct GeminiAPIResponse: Decodable { let candidates: [Candidate]? }
    struct Candidate: Decodable { let content: ResponseContent }
    struct ResponseContent: Decodable { let parts: [ResponsePart] }
    struct ResponsePart: Decodable { let text: String? }
}
