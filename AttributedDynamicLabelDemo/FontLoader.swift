import UIKit

/// Default font to be included with UIHelpers library
public struct SanFranciscoDisplay: CustomFont {
    public static func name(forWeight weight: CustomFontWeight) -> String {
        switch weight {
        case .ultralight:
            return ".SFUIText-Ultralight"
        case .thin:
            return ".SFUIText-Thin"
        case .light:
            return ".SFUIText-Light"
        case .medium:
            return ".SFUIText-Medium"
        case .book:
            return ".SFUIText"
        case .regular:
            return ".SFUIText"
        case .semibold:
            return ".SFUIText-Semibold"
        case .bold:
            return ".SFUIText-Bold"
        case .heavy:
            return ".SFUIText-Heavy"
        case .black:
            return ".SFUIText-Black"
        default:
            fatalError("Specified font weight is not mapped to a font file")
        }
    }
}

/// Loading custom fonts for unit testing. Because of issues with bundles, they must be manually
/// added.
///
/// - Parameter: for fontExtension: the font format/extension which will be loaded.
///              Defaults to "otf"
///
/// Borrowed from https://stackoverflow.com/a/47514683
///
public final class FontLoader {

    @discardableResult
    public class func loadCustomFonts(for fontExtension: String = "otf",
                                      in bundle: Bundle = Bundle(for: FontLoader.self)) -> Bool {
        let fileManager = FileManager.default
        let bundleURL = bundle.bundleURL
        do {
            let contents = try fileManager.contentsOfDirectory(at: bundleURL,
                                                               includingPropertiesForKeys: [],
                                                               options: .skipsHiddenFiles)
            for url in contents {
                if url.pathExtension == fontExtension {
                    guard let fontData = NSData(contentsOf: url) else {
                        continue
                    }
                    let provider = CGDataProvider(data: fontData)
                    if let font = CGFont(provider!) {
                        print("Registering font \(font)")
                        CTFontManagerRegisterGraphicsFont(font, nil)
                    } else {
                        fatalError("Could not create custom font from CGDataProvider")
                    }
                }
            }
        } catch {
            fatalError("Error while loading custom font: \(error)")
        }
        return true
    }
}
