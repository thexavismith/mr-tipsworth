import SwiftUI

struct TipDialView: View {
    @Binding var tipPercent: Int
    @Environment(ThemeStore.self) private var themeStore

    static let range: ClosedRange<Int> = 15...50
    static let snapPoints: [Int] = [15, 18, 20, 25]
    private let snapThreshold = 2

    @State private var rotation: Double = 0
    @State private var dragStartAngle: Double?

    var body: some View {
        ZStack {
            dialFace
            snapPips
            centerLabel
        }
        .frame(width: 260, height: 260)
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
            case .increment: tipPercent = min(tipPercent + 1, Self.range.upperBound)
            case .decrement: tipPercent = max(tipPercent - 1, Self.range.lowerBound)
            @unknown default: break
            }
        }
    }

    private var dialFace: some View {
        Circle()
            .fill(themeStore.activeTheme.dialFace)
            .overlay {
                Circle()
                    .strokeBorder(themeStore.activeTheme.accent, lineWidth: 4)
            }
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

    private var centerLabel: some View {
        Text("\(tipPercent)%")
            .font(.system(size: 48, weight: .bold, design: .rounded))
            .foregroundStyle(themeStore.activeTheme.primaryText)
            .contentTransition(.numericText())
    }

    private var circularDragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                let center = CGPoint(x: 130, y: 130)
                let angle = atan2(
                    value.location.y - center.y,
                    value.location.x - center.x
                )
                if let startAngle = dragStartAngle {
                    let delta = angle - startAngle
                    let degreesPerPercent = 360.0 / Double(Self.range.upperBound - Self.range.lowerBound)
                    let percentDelta = Int((delta * (180 / .pi)) / degreesPerPercent)
                    let newPercent = (tipPercent + percentDelta).clamped(to: Self.range)
                    if newPercent != tipPercent {
                        tipPercent = newPercent
                        dragStartAngle = angle
                    }
                } else {
                    dragStartAngle = angle
                }
            }
            .onEnded { _ in
                dragStartAngle = nil
                snapToNearestPreset()
            }
    }

    private func snapToNearestPreset() {
        guard let nearest = Self.snapPoints.min(by: { abs($0 - tipPercent) < abs($1 - tipPercent) }),
              abs(nearest - tipPercent) <= snapThreshold else { return }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            tipPercent = nearest
        }
    }
}

private struct SnapPipView: View {
    let percent: Int
    let range: ClosedRange<Int>
    let dialRotation: Double
    let pipColor: Color

    var body: some View {
        Circle()
            .fill(pipColor)
            .frame(width: 8, height: 8)
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
