import Testing
@testable import MrTipsworth

@MainActor
struct TipCalculationTests {
    @Test func tipAmountCalculation() {
        let calc = TipCalculation()
        calc.billAmount = 100
        calc.tipPercent = 20
        #expect(calc.tipAmount == 20)
        #expect(calc.rawTotal == 120)
    }

    @Test func roundingRoundsUp() {
        let calc = TipCalculation()
        calc.billAmount = 22.30
        calc.tipPercent = 0
        calc.isRounding = true
        #expect(calc.roundedTotal == 23)
    }

    @Test func effectiveTipAppearsOnlyWhenRounding() {
        let calc = TipCalculation()
        calc.billAmount = 100
        calc.tipPercent = 18
        #expect(calc.effectiveTipPercent == nil)
        calc.isRounding = true
        #expect(calc.effectiveTipPercent != nil)
    }

    @Test func noTipWhenBillIsNil() {
        let calc = TipCalculation()
        #expect(calc.tipAmount == 0)
        #expect(calc.displayTotal == 0)
    }
}
