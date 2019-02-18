import UIKit
import os.log

public protocol CustomFont {
    /// All CustomFonts must return a proper PostScript name of a loaded font.
    static func name(forWeight weight: CustomFontWeight) -> String
}

/// More granular weights than UIFont.Weights. Should allow for using exact weight as specified
/// in the Sketch/Zeplin file as long as that specific weight is mapped to an appropriate PostScript
/// name of a loaded font (either in the system or loaded by FontLoader).
public enum CustomFontWeight {
    case ultralight
    case thin
    case light
    case regular
    case regularItalic
    case book
    case bookItalic
    case medium
    case demi
    case semibold
    case bold
    case heavy
    case black

    /// Map all special weights to standard UIFont.Weight in case of falling back on systemFonts
    var standardWeight: UIFont.Weight {
        switch self {
        case .ultralight:       return UIFont.Weight.ultraLight
        case .thin:             return UIFont.Weight.thin
        case .light:            return UIFont.Weight.light
        case .regular:          return UIFont.Weight.regular
        case .regularItalic:    return UIFont.Weight.regular
        case .book:             return UIFont.Weight.regular
        case .bookItalic:       return UIFont.Weight.regular
        case .medium:           return UIFont.Weight.medium
        case .demi:             return UIFont.Weight.medium
        case .semibold:         return UIFont.Weight.semibold
        case .bold:             return UIFont.Weight.bold
        case .heavy:            return UIFont.Weight.heavy
        case .black:            return UIFont.Weight.black
        }
    }
}

extension UIFont {

    static let log = OSLog(subsystem: "com.livefront.uihelper", category: "Fonts")

    /// Returns a scaled `UIFont` instance at the specified point size and style.
    ///
    /// - Parameter
    ///   - style: The font style
    ///   - points: The font point size.
    ///   - maximumPointSize: The maximum point size to scale up to. Defaults to nil, which doesn't
    ///     limit the maximum point size.
    /// - Returns: The scaled font instance.
    ///
    public static func customFont(
        _ withCustomfont: CustomFont.Type = SanFranciscoDisplay.self,
        weight customWeight: CustomFontWeight = .regular,
        points: CGFloat = 24.0,
        maximumPointSize: CGFloat? = nil) -> UIFont {

        var font: UIFont

        if let specificFont = UIFont(name: withCustomfont.name(forWeight: customWeight), size: points) {
            font = specificFont
        } else {
            os_log("Warning: Font file with %@ not found.", log: log, type: .info,
                   withCustomfont.name(forWeight: customWeight))
            font = UIFont.systemFont(ofSize: points, weight: customWeight.standardWeight)
        }

        if let maximumPointSize = maximumPointSize {
            return FontMetrics.default.scaledFont(for: font, maximumPointSize: maximumPointSize)
        } else {
            return FontMetrics.default.scaledFont(for: font)
        }
    }
}
