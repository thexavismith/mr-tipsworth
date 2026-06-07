import SwiftUI
import AudioToolbox

struct TipDialView: View {
    @Binding var tipPercent: Int
    @Environment(ThemeStore.self) private var themeStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    static let range: ClosedRange<Int> = 15...50
    static let snapPoints: [Int] = [15, 18, 20, 25]
    private let snapThreshold = 2

    @State private var rotation: Double = 0
    @State private var dragStartAngle: Double?
    @State private var accumulatedDegrees: Double = 0
    @State private var snapScale: CGFloat = 1.0
    @State private var isOnSnapPoint: Bool = true

    // Momentum
    @State private var angularVelocity: Double = 0
    @State private var lastAngleTime: Date = .now
    @State private var momentumTask: Task<Void, Never>?

    // Directional animation
    @State private var lastTipPercent: Int = 15

    private let dialSize: CGFloat = 300
    private let centerButtonSize: CGFloat = 136
    private let outerSize: CGFloat = 370 // frame including label space
    private var deadZoneRadius: CGFloat { centerButtonSize / 2 }
    private let degreesPerPercent: Double =
        (360.0 / Double(TipDialView.range.upperBound - TipDialView.range.lowerBound)) / 2

    var body: some View {
        ZStack {
            // Snap point labels sit outside the ring
            snapLabels

            dialRing
            centerButton
        }
        .frame(width: outerSize, height: outerSize)
        // Gesture only active on the dial ring area
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
        .onChange(of: tipPercent) { old, new in
            lastTipPercent = old
            isOnSnapPoint = Self.snapPoints.contains(new)

            if isOnSnapPoint && !reduceMotion {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.4)) {
                    snapScale = 1.08
                } completion: {
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                        snapScale = 1.0
                    }
                }
            }
        }
    }

    // MARK: - Subviews

    private var dialRing: some View {
        ZStack {
            Circle()
                .fill(themeStore.activeTheme.dialFace)

            ForEach(0..<72, id: \.self) { tick in
                Capsule()
                    .fill(themeStore.activeTheme.accentText.opacity(0.2))
                    .frame(width: 1, height: 6)
                    .offset(y: -(dialSize / 2 - 9))
                    .rotationEffect(.degrees(Double(tick) * 5))
            }
        }
        .frame(width: dialSize, height: dialSize)
        .rotationEffect(.degrees(rotation))
    }

    // Fixed labels outside the ring at each snap point position
    private var snapLabels: some View {
        ForEach(Self.snapPoints, id: \.self) { point in
            SnapLabelView(
                percent: point,
                range: Self.range,
                dialSize: dialSize,
                outerSize: outerSize,
                isActive: tipPercent == point,
                activeColor: themeStore.activeTheme.accentText,
                inactiveColor: themeStore.activeTheme.secondaryText
            )
        }
    }

    // Small filled triangle pointing inward at 12 o'clock
    private var positionMarker: some View {
        VStack(spacing: 0) {
            Triangle()
                .fill(themeStore.activeTheme.accentText)
                .frame(width: 10, height: 8)
                .padding(.top, (outerSize - dialSize) / 2 - 10)
            Spacer()
        }
        .frame(width: outerSize, height: outerSize)
    }

    private var centerButton: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .shadow(color: .black.opacity(0.12), radius: 16, x: 0, y: 4)
                .overlay {
                    Circle()
                        .strokeBorder(themeStore.activeTheme.accentFill, lineWidth: isOnSnapPoint ? 3 : 0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isOnSnapPoint)
                }

            centerLabel
        }
        .frame(width: centerButtonSize, height: centerButtonSize)
        .scaleEffect(snapScale)
    }

    private var centerLabel: some View {
        Text("\(tipPercent)%")
            .font(.system(size: 40, weight: .black, design: .rounded))
            .foregroundStyle(themeStore.activeTheme.primaryText)
            .contentTransition(.numericText(countsDown: tipPercent < lastTipPercent))
            .animation(.snappy(duration: 0.2), value: tipPercent)
    }

    // MARK: - Gesture

    private var circularDragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                momentumTask?.cancel()

                let center = CGPoint(x: outerSize / 2, y: outerSize / 2)
                let distFromCenter = hypot(value.location.x - center.x, value.location.y - center.y)

                guard distFromCenter > deadZoneRadius && distFromCenter <= outerSize / 2 else {
                    if distFromCenter <= deadZoneRadius { dragStartAngle = nil }
                    return
                }

                let angle = atan2(value.location.y - center.y, value.location.x - center.x)
                guard let startAngle = dragStartAngle else {
                    dragStartAngle = angle
                    lastAngleTime = .now
                    return
                }

                var delta = angle - startAngle
                if delta > .pi { delta -= 2 * .pi }
                if delta < -.pi { delta += 2 * .pi }

                let now = Date.now
                let elapsed = now.timeIntervalSince(lastAngleTime)
                if elapsed > 0 { angularVelocity = delta / elapsed }
                lastAngleTime = now

                let degreesDelta = delta * (180 / .pi)
                accumulatedDegrees += degreesDelta
                rotation += degreesDelta
                dragStartAngle = angle

                while accumulatedDegrees >= degreesPerPercent {
                    accumulatedDegrees -= degreesPerPercent
                    updateTip(by: 1)
                    playTickSound()
                }
                while accumulatedDegrees <= -degreesPerPercent {
                    accumulatedDegrees += degreesPerPercent
                    updateTip(by: -1)
                    playTickSound()
                }
            }
            .onEnded { _ in
                dragStartAngle = nil
                accumulatedDegrees = 0
                let velocity = angularVelocity

                let snapped = snapToNearestPreset()
                if !snapped && abs(velocity) > 0.3 {
                    applyMomentum(velocity: velocity)
                }
                angularVelocity = 0
            }
    }

    // MARK: - Momentum

    private func applyMomentum(velocity: Double) {
        momentumTask = Task {
            var vel = velocity * (180 / .pi)
            let friction = 0.88

            while !Task.isCancelled && abs(vel) > 0.5 {
                try? await Task.sleep(for: .seconds(1.0 / 60.0))
                guard !Task.isCancelled else { break }
                vel *= friction
                let degreesDelta = vel * (1.0 / 60.0)

                await MainActor.run {
                    accumulatedDegrees += degreesDelta
                    rotation += degreesDelta

                    while accumulatedDegrees >= degreesPerPercent {
                        accumulatedDegrees -= degreesPerPercent
                        updateTip(by: 1)
                        playTickSound()
                    }
                    while accumulatedDegrees <= -degreesPerPercent {
                        accumulatedDegrees += degreesPerPercent
                        updateTip(by: -1)
                        playTickSound()
                    }
                }
            }
            await MainActor.run {
                accumulatedDegrees = 0
                _ = snapToNearestPreset()
            }
        }
    }

    // MARK: - Helpers

    @discardableResult
    private func snapToNearestPreset() -> Bool {
        guard let nearest = Self.snapPoints.min(by: { abs($0 - tipPercent) < abs($1 - tipPercent) }),
              abs(nearest - tipPercent) <= snapThreshold else { return false }

        let degreesDelta = Double(nearest - tipPercent) * degreesPerPercent
        withAnimation(.spring(response: 0.4, dampingFraction: 0.55)) {
            tipPercent = nearest
            rotation += degreesDelta
        }
        return true
    }

    private func updateTip(by delta: Int) {
        let span = Self.range.upperBound - Self.range.lowerBound + 1
        let offset = (tipPercent + delta - Self.range.lowerBound) % span
        tipPercent = Self.range.lowerBound + (offset < 0 ? offset + span : offset)
    }

    private func playTickSound() {
        AudioServicesPlaySystemSound(1157)
    }
}

// MARK: - Snap Label

private struct SnapLabelView: View {
    let percent: Int
    let range: ClosedRange<Int>
    let dialSize: CGFloat
    let outerSize: CGFloat
    let isActive: Bool
    let activeColor: Color
    let inactiveColor: Color

    var body: some View {
        // Orbit: rotate the label to its position, offset outward, counter-rotate text upright
        Text("\(percent)%")
            .font(.system(size: 12, weight: isActive ? .bold : .medium, design: .rounded))
            .foregroundStyle(isActive ? activeColor : inactiveColor)
            .animation(.easeInOut(duration: 0.15), value: isActive)
            .rotationEffect(.degrees(-orbitAngle)) // keep text upright
            .offset(y: -(dialSize / 2 + 20))
            .rotationEffect(.degrees(orbitAngle), anchor: .center)
    }

    private var orbitAngle: Double {
        let span = Double(range.upperBound - range.lowerBound)
        return (Double(percent - range.lowerBound) / span) * 360
    }
}

// MARK: - Triangle Shape

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
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
        .background(Color.warmCream)
}
