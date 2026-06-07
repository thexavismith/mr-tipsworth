import Foundation

@MainActor
@Observable
final class TipCalculation {
    var billAmount: Double?
    var tipPercent: Int = 15
    var isRounding: Bool = false

    var tipAmount: Double {
        guard let bill = billAmount else { return 0 }
        return bill * (Double(tipPercent) / 100)
    }

    var rawTotal: Double {
        guard let bill = billAmount else { return 0 }
        return bill + tipAmount
    }

    var roundedTotal: Double {
        ceil(rawTotal)
    }

    var displayTotal: Double {
        isRounding ? roundedTotal : rawTotal
    }

    var effectiveTipPercent: Double? {
        guard isRounding, let bill = billAmount, bill > 0 else { return nil }
        return ((roundedTotal - bill) / bill) * 100
    }
}
