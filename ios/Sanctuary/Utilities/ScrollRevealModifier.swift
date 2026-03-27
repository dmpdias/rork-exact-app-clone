import SwiftUI

struct ScrollRevealModifier: ViewModifier {
    let delay: Double
    @State private var appeared: Bool = false

    func body(content: Content) -> some View {
        content
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 16)
            .animation(.easeOut(duration: 0.4).delay(delay), value: appeared)
            .onAppear {
                appeared = true
            }
    }
}

extension View {
    func scrollReveal(delay: Double = 0) -> some View {
        modifier(ScrollRevealModifier(delay: delay))
    }
}
