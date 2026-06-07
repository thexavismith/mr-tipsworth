import SwiftUI

struct CelebrationParticleView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var particles: [Particle] = []

    private let particleCount = 55

    var body: some View {
        if reduceMotion {
            Color.clear
        } else {
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    let now = timeline.date.timeIntervalSinceReferenceDate
                    for particle in particles {
                        particle.draw(in: context, size: size, now: now)
                    }
                } symbols: {
                    ForEach(Particle.Symbol.allCases) { sym in
                        ForEach(Particle.palette.indices, id: \.self) { colorIdx in
                            Image(systemName: sym.rawValue)
                                .foregroundStyle(Particle.palette[colorIdx])
                                .tag("\(sym.rawValue)-\(colorIdx)")
                        }
                    }
                }
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)
            .onAppear {
                particles = (0..<particleCount).map { _ in Particle() }
            }
        }
    }
}

struct Particle {
    enum Symbol: String, CaseIterable, Identifiable {
        case circle  = "circle.fill"
        case star    = "star.fill"
        case sparkle = "sparkle"
        var id: String { rawValue }
    }

    static let palette: [Color] = [.warmYellow, .cozyPeach, .sparkleGold, .tealBlue]

    let startTime: Double
    let lifetime: Double
    let startX: Double
    let velocityX: Double
    let velocityY: Double
    let rotationSpeed: Double
    let scale: Double
    let symbol: Symbol
    let colorIndex: Int

    init() {
        startTime = Date.now.timeIntervalSinceReferenceDate + Double.random(in: 0...0.7)
        lifetime  = Double.random(in: 1.5...2.4)
        startX    = Double.random(in: 0.05...0.95)
        velocityX = Double.random(in: -0.12...0.12)
        velocityY = Double.random(in: 0.22...0.52)
        rotationSpeed = Double.random(in: -3.0...3.0)
        scale      = Double.random(in: 0.5...1.3)
        symbol     = Symbol.allCases.randomElement()!
        colorIndex = (0..<Self.palette.count).randomElement()!
    }

    func draw(in context: GraphicsContext, size: CGSize, now: Double) {
        let elapsed = now - startTime
        guard elapsed > 0, elapsed < lifetime else { return }

        let progress = elapsed / lifetime
        // fade in over first 10%, fade out over last 20%
        let opacity: Double = if progress < 0.1 {
            progress / 0.1
        } else if progress > 0.8 {
            1 - ((progress - 0.8) / 0.2)
        } else {
            1.0
        }

        let xPos = (startX + velocityX * elapsed) * size.width
        let yPos = 0.1 * size.height + velocityY * elapsed * size.height
        let rotation = Angle(radians: rotationSpeed * elapsed)
        let side = 18.0 * scale

        guard let resolved = context.resolveSymbol(id: "\(symbol.rawValue)-\(colorIndex)") else { return }

        var ctx = context
        ctx.opacity = max(0, opacity)
        ctx.translateBy(x: xPos, y: yPos)
        ctx.rotate(by: rotation)
        ctx.draw(resolved, in: CGRect(x: -side / 2, y: -side / 2, width: side, height: side))
    }
}
