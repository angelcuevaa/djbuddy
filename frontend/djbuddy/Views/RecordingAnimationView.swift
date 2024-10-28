import SwiftUI

struct RecordingAnimationView: View {
    @Binding var isListening: Bool // Binding variable to control animation
    @State private var scale: CGFloat = 1.0
    @State private var isAnimating: Bool = false
    @State private var outerCircleScales: [CGFloat] = []
    @State private var outerCircleOpacities: [Double] = [] // Track opacity for fading effect

    var body: some View {
        ZStack {
            // Background Circles for Pulsing Effect
            ForEach(outerCircleScales.indices, id: \.self) { index in
                Circle()
                    .fill(Color.blue.opacity(0.3))
                    .scaleEffect(outerCircleScales[index])
                    .opacity(outerCircleOpacities[index]) // Apply opacity for fade effect
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: outerCircleScales[index]) // Animate outer circle scaling
            }

            Circle() // Main circle
                .fill(Color.blue)
                .scaleEffect(scale)
                .onAppear {
                    isAnimating = true
                    animate() // Start animation on appear
                }
        }
        .frame(width: 150, height: 150) // Size of the main animation
        .onDisappear {
            resetAnimation()
        }
        .onChange(of: isListening) {
            if isListening {
                animateOuterCircles() // Start creating outer circles when listening starts
            } else {
                resetOuterCircles() // Reset outer circles when listening stops
            }
        }
    }

    private func animate() {
        if isAnimating {
            // Pulse animation for the main circle when listening
            withAnimation {
                scale = scale == 1.0 ? 1.2 : 1.0 // Pulse effect
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                animate() // Recursive call to keep animating
            }
        }
    }

    private func animateOuterCircles() {
        // Continuously create outer circles for pulsing effect
        let newOuterCircleScale = CGFloat.random(in: 1.2...1.5)
        outerCircleScales.append(newOuterCircleScale)
        outerCircleOpacities.append(1.0) // Set initial opacity to 1.0

        // Animate the new outer circle to fade out and shrink
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                outerCircleScales[outerCircleScales.count - 1] = 0.0 // Animate scale to 0
                outerCircleOpacities[outerCircleOpacities.count - 1] = 0.0 // Animate opacity to 0
            }
        }

        // Call again to keep adding circles every 0.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if isListening { // Ensure we are still listening before creating another circle
                animateOuterCircles() // Recursive call to keep adding outer circles
            }
        }
    }

    private func resetOuterCircles() {
        outerCircleScales.removeAll() // Clear any outer circles when resetting
        outerCircleOpacities.removeAll() // Clear opacities as well
    }

    private func resetAnimation() {
        scale = 1.0
        isAnimating = false
        resetOuterCircles() // Clear outer circles when resetting
    }
}
