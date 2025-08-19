//
//  Extensions.swift
//  GiftMate
//
//  Created by D K on 11.08.2025.
//

import SwiftUI

extension Color {
    static let themeBackground = Color(hex: "130d0d")
    static let themeCardBackground = Color(hex: "211c17")
    static let themePrimaryText = Color.white
    static let themeSecondaryText = Color(hex: "a0a6c6")
    static let themePlaceholder = Color(hex: "6a78b8")
    static let themeAccentGreen = Color(hex: "2faa53")
    static let themeAccentYellow = Color(hex: "db382c")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}


extension View {
    
    @ViewBuilder
      func hideListRowSeparator() -> some View {
          if #available(iOS 15.0, *) {
              self.listRowSeparator(.hidden)
          } else {
              self
          }
      }
    
    @ViewBuilder
      func customBackground(_ color: Color) -> some View {
          if #available(iOS 15.0, *) {
              self.background(color)
          } else {
              self
          }
      }
    
    @ViewBuilder
    func applyTint(_ color: Color) -> some View {
        if #available(iOS 16.0, *) {
            self.tint(color)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func swipeActionsWrapper<V: View>(
        allowsFullSwipe: Bool = true,
        @ViewBuilder content: @escaping () -> V
    ) -> some View {
        if #available(iOS 15.0, *) {
            self
                .swipeActions(edge: .trailing, allowsFullSwipe: allowsFullSwipe, content: content)
                .swipeActions(edge: .trailing, allowsFullSwipe: allowsFullSwipe) {
                    // Мы можем оставить здесь пустоту или добавить общие действия
                }
        } else {
            self
        }
    }
    
    @ViewBuilder
    func destructiveButton(
        _ title: String,
        action: @escaping () -> Void
    ) -> some View {
        if #available(iOS 15.0, *) {
            Button(role: .destructive, action: action) {
                Text(title)
            }
        } else {
            Button(action: action) {
                Text(title)
            }
        }
    }
}

@ViewBuilder
func destructiveButton(
    title: String,
    systemImage: String,
    action: @escaping () -> Void
) -> some View {
    if #available(iOS 15.0, *) {
        Button(role: .destructive, action: action) {
            Label(title, systemImage: systemImage)
        }
    } else {
        Button(action: action) {
            Label(title, systemImage: systemImage)
        }
    }
}



extension View {  
    
    @ViewBuilder
    func swipeActionsWrapper<V: View>(
        edge: Edge = .trailing,
        allowsFullSwipe: Bool = true,
        @ViewBuilder content: @escaping () -> V
    ) -> some View {
        if #available(iOS 15.0, *) {
            // HorizontalEdge доступен только с iOS 15
            let horizontalEdge = (edge == .leading) ? HorizontalEdge.leading : HorizontalEdge.trailing
            self.swipeActions(edge: horizontalEdge, allowsFullSwipe: allowsFullSwipe, content: content)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func compatibilityAlert<A: View, M: View>(
        _ title: String,
        isPresented: Binding<Bool>,
        @ViewBuilder actions: @escaping () -> A,
        @ViewBuilder message: @escaping () -> M
    ) -> some View {
        if #available(iOS 15.0, *) {
            self.alert(title, isPresented: isPresented, actions: actions, message: message)
        } else {
            self.alert(isPresented: isPresented) {
                Alert(title: Text(title),
                      message: message().toText(), // Преобразуем message View в Text
                      dismissButton: .default(Text("OK")))
                // Примечание: старый Alert не поддерживает кастомные кнопки так же гибко,
                // поэтому для iOS 14 будет показан только базовый Alert.
                // Действия (actions) будут проигнорированы.
            }
        }
    }
}

private extension View {
    func toText() -> Text? {
        if let text = self as? Text {
            return text
        }
        return nil
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(16)
            .background(Color.themeCardBackground)
            .cornerRadius(12)
            .foregroundColor(.themePrimaryText)
            .accentColor(.themeAccentYellow)
    }
}

extension View {
    func size() -> CGSize {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        return window.screen.bounds.size
    }
}
