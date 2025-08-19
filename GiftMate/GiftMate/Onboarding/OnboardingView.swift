import SwiftUI

private struct OnboardingFeature: Identifiable {
    let id = UUID()
    let iconName: String
    let title: String
    let description: String
    let color: Color
}

struct OnboardingViewV2: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @Environment(\.presentationMode) var presentationMode
    
    private let features: [OnboardingFeature] = [
        OnboardingFeature(
            iconName: "wand.and.stars",
            title: "Your Personal Wishlist",
            description: "Create and organize your desires into categories. Share them easily when friends ask what you'd like.",
            color: .themeAccentYellow
        ),
        OnboardingFeature(
            iconName: "person.3.fill",
            title: "Gift Ideas for Friends",
            description: "Never forget a great gift idea again. Store inspirations for each friend and be ready for any occasion.",
            color: .themeAccentGreen
        ),
        OnboardingFeature(
            iconName: "sparkles",
            title: "AI-Powered Suggestions",
            description: "Stuck for ideas? Let our AI generate personalized gift suggestions based on interests, budget, and more.",
            color: Color(hex: "#6a78b8")
        ),
        OnboardingFeature(
            iconName: "gift.fill",
            title: "Birthday Reminders",
            description: "Keep track of important dates with a visual calendar and get timely reminders so you're always prepared.",
            color: .red
        )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 80) {
                    HeaderView()
                    
                    ForEach(features) { feature in
                        FeatureView(feature: feature)
                    }
                    
                    Spacer(minLength: 100)
                }
            }
            
            Button("Get Started") {
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(30)
        }
        .background(Color.themeBackground.ignoresSafeArea())
        .foregroundColor(.themePrimaryText)
    }
}


private struct HeaderView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome to")
                .font(.largeTitle)
                .foregroundColor(.themeSecondaryText)
            
            Text("GiftMate")
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(.themeAccentYellow)
                .shadow(color: .themeAccentYellow.opacity(0.5), radius: 10)
            
            Text("The smart way to give.")
                .font(.title3)
        }
        .padding(.top, 80)
    }
}

private struct FeatureView: View {
    let feature: OnboardingFeature
    @State private var isVisible = false
    
    var body: some View {
        HStack(spacing: 24) {
            Image(systemName: feature.iconName)
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(feature.color)
                .frame(width: 60, height: 60)
                .background(Color.themeCardBackground)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(feature.title)
                    .font(.title2).bold()
                
                Text(feature.description)
                    .foregroundColor(.themeSecondaryText)
            }
        }
        .padding(.horizontal, 30)
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 30)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                isVisible = true
            }
        }
    }
}

#Preview {
    OnboardingViewV2()
}
