import Foundation

public struct ACustomFont: CustomFont {
    public static func name(forWeight weight: CustomFontWeight) -> String {
        switch weight {
        case .demi:
            return "Courier-Bold"
        default:
            fatalError("Specified font weight is not mapped to a font file")
        }
    }
}
