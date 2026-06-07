import SwiftUI

struct TipDialView: View {
    @Binding var tipPercent: Int
    @Environment(ThemeStore.self) private var themeStore

    static let range: ClosedRange<Int> = 15...50
    static let snapPoints: [Int] = [15, 18, 20, 25]
    private let snapThreshold = 2

    // Accumulated rotation in degrees, updated live during drag
    @State private var rotation: Double = 0
    @State private var dragStartAngle: Double?
    // Sub-percent degree accumulator — fires a tick when it crosses ±degreesPerPercent
    @State private var accumulatedDegrees: Double = 0

    private let dialSize: CGFloat = 280
    private let centerButtonSize: CGFloat = 110
    private let degreesPerPercent: Double =
        (360.0 / Double(TipDialView.range.upperBound - TipDialView.range.lowerBound)) / 2

    var body: some View {
        ZStack {
            dialRing
            snapPips
            centerButton
        }
        .frame(width: dialSize, height: dialSize)
        .gesture(circularDragGesture)
        .sensoryFeedback(.impact(weight: .light), trigger: tipPercent) { old, new in
            Self.snapPoints.contains(new) && old != new
        }
        .sensoryFeedback(.impact(weight: .light, intensity: 0.4), trigger: tipPercent) { old, new in
            !Self.snapPoints.contains(new) && old != new
        }
        .accessibilityElement()
        .accessibilityLabel("Tip percentage")
        .accessibilityValue("Tip: \(tipPercent)%")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: updateTip(by: 1)
            case .decrement: updateTip(by: -1)
            @unknown default: break
            }
        }

    }

    // Outer rotating ring — solid filled circle with tick marks and border on top
    private var dialRing: some View {
        ZStack {
            Circle()
                .fill(themeStore.activeTheme.dialFace)

            // Grippy tick marks near the edge of the ring
            ForEach(0..<36, id: \.self) { tick in
                Capsule()
                    .fill(themeStore.activeTheme.accent.opacity(0.25))
                    .frame(width: 2, height: 10)
                    .offset(y: -(dialSize / 2 - 12))
                    .rotationEffect(.degrees(Double(tick) * 10))
            }

            Circle()
                .strokeBorder(themeStore.activeTheme.accent, lineWidth: 3)
        }
        .frame(width: dialSize, height: dialSize)
        .rotationEffect(.degrees(rotation))
    }

    private var snapPips: some View {
        ForEach(Self.snapPoints, id: \.self) { point in
            SnapPipView(
                percent: point,
                range: Self.range,
                dialRotation: rotation,
                pipColor: themeStore.activeTheme.dialPip
            )
        }
    }

    // Fixed center button — distinct surface color, raised shadow
    private var centerButton: some View {
        ZStack {
            Circle()
                .fill(themeStore.activeTheme.surface)
                .shadow(color: .black.opacity(0.22), radius: 8, x: 0, y: 4)
                .overlay {
                    Circle()
                        .strokeBorder(themeStore.activeTheme.accent.opacity(0.35), lineWidth: 1.5)
                }
            centerLabel
        }
        .frame(width: centerButtonSize, height: centerButtonSize)
    }

    private var centerLabel: some View {
        Text("\(tipPercent)%")
            .font(.system(size: 32, weight: .bold, design: .rounded))
            .foregroundStyle(themeStore.activeTheme.primaryText)
            .contentTransition(.numericText())
            .animation(.snappy(duration: 0.2), value: tipPercent)
    }

    private var circularDragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                let center = CGPoint(x: dialSize / 2, y: dialSize / 2)
                let angle = atan2(
                    value.location.y - center.y,
                    value.location.x - center.x
                )
                guard let startAngle = dragStartAngle else {
                    dragStartAngle = angle
                    return
                }

                var delta = angle - startAngle
                // Wrap large jumps (crossing the ±π boundary)
                if delta > .pi { delta -= 2 * .pi }
                if delta < -.pi { delta += 2 * .pi }

                let degreesDelta = delta * (180 / .pi)
                accumulatedDegrees += degreesDelta
                rotation += degreesDelta
                dragStartAngle = angle

                // Clockwise drag = positive degreesDelta = increase tip
                while accumulatedDegrees >= degreesPerPercent {
                    accumulatedDegrees -= degreesPerPercent
                    updateTip(by: 1)
                }
                while accumulatedDegrees <= -degreesPerPercent {
                    accumulatedDegrees += degreesPerPercent
                    updateTip(by: -1)
                }
            }
            .onEnded { _ in
                dragStartAngle = nil
                accumulatedDegrees = 0
                snapToNearestPreset()
            }
    }

    private func updateTip(by delta: Int) {
        let newPercent = (tipPercent + delta).clamped(to: Self.range)
        tipPercent = newPercent
    }

    private func snapToNearestPreset() {
        guard let nearest = Self.snapPoints.min(by: { abs($0 - tipPercent) < abs($1 - tipPercent) }),
              abs(nearest - tipPercent) <= snapThreshold else { return }
        let degreesDelta = Double(nearest - tipPercent) * degreesPerPercent
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            tipPercent = nearest
            rotation += degreesDelta
        }
    }
}

private struct SnapPipView: View {
    let percent: Int
    let range: ClosedRange<Int>
    let dialRotation: Double
    let pipColor: Color

    var body: some View {
        Capsule()
            .fill(pipColor)
            .frame(width: 5, height: 14)
            .offset(y: -120)
            .rotationEffect(.degrees(angleForPercent))
    }

    private var angleForPercent: Double {
        let span = Double(range.upperBound - range.lowerBound)
        return ((Double(percent - range.lowerBound) / span) * 360) - dialRotation
    }
}

private extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

#Preview {
    TipDialView(tipPercent: .constant(20))
        .environment(ThemeStore())
        .padding()
}
