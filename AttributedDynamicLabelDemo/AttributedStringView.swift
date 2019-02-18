import Foundation
import UIKit

// MARK: - AttributedStringView
class AttributedStringView: UIView {

    /// `FontSetter` is a closure type used to recalculate the font size.
    typealias FontSetter = () -> UIFont

    /// `FontSetterAttributeKey` is used to keep track of the custom Font assigned to a range within
    /// an `AttributedString`.
    static let FontSetterAttributeKey = NSAttributedString.Key.init("FontSetterAttributeKey")

    /// A `UILabel` that will render the attributed string with Dynamic Type.
    lazy var display: UILabel = {
        let fontSetter1: FontSetter = { UIFont.customFont(weight: .bold, points: 18.0) }

        let string1 = NSAttributedString(
            string: "Jived fox nymph grabs quick waltz. ",
            attributes: [AttributedStringView.FontSetterAttributeKey : fontSetter1,
                         .font: fontSetter1()
            ]
        )


        let fontSetter2: FontSetter = { UIFont.customFont(weight: .light, points: 8.0) }
        let string2 = NSAttributedString(
            string: "Glib jocks quiz nymph to vex dwarf. ",
            attributes: [AttributedStringView.FontSetterAttributeKey : fontSetter2,
                         .font: fontSetter2()
            ]
        )

        let fontSetter3: FontSetter = { UIFont.customFont(ACustomFont.self,
                                                          weight: .demi,
                                                          points: 18.0,
                                                          maximumPointSize: 24.0) }
        let string3 = NSAttributedString(
            string: "Sphinx of black quartz, judge my vow. ",
            attributes: [AttributedStringView.FontSetterAttributeKey : fontSetter3,
                         .font: fontSetter3()
            ]
        )

        let fontSetter4: FontSetter = { UIFont.customFont(weight: .heavy,
                                                          points: 48.0) }
        let string4 = NSAttributedString(
            string: "How vexingly quick daft zebras jump!",
            attributes: [AttributedStringView.FontSetterAttributeKey : fontSetter4,
                         .font: fontSetter4()
            ]
        )

        var totalAttributedString = NSMutableAttributedString(attributedString: string1)
        totalAttributedString.append(string2)
        totalAttributedString.append(string3)
        totalAttributedString.append(string4)

        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.attributedText = totalAttributedString
        label.translatesAutoresizingMaskIntoConstraints = false

        NotificationCenter.default.addObserver(self,
                                               selector: #selector (uiContentSizeCategoryChanged),
                                               name: .FontMetricsContentSizeCategoryDidChange,
                                               object: nil)

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(display)
        NSLayoutConstraint.activate([
            display.topAnchor.constraint(equalTo: topAnchor),
            display.bottomAnchor.constraint(equalTo: bottomAnchor),
            display.leadingAnchor.constraint(equalTo: leadingAnchor),
            display.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
    }

    /// Although "required," we don't have to implement init(coder:) for now
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented for this article.")
    }

    // MARK: Event Handlers

    /// Update the sizes of all contained fonts whenever the Dynamic Type size changes.
    @objc func uiContentSizeCategoryChanged() {

        /// Unwrap the optional attributedText property on `UILabel`.
        guard let attributedString = display.attributedText else {
            /// If for some reason the `attributedText` is nil, do nothing for this demo.
            return
        }

        /// The preexisting formatted string.
        let mutableText = NSMutableAttributedString(attributedString: attributedString)

        /// The full range of the attributed text (NSRange takes care of the edge cases related to
        /// formatting).
        let fullTextRange = NSRange(location: 0, length: mutableText.string.count)

        /// Enumerate over the full range of the formatted string and grab attributes within it.
        mutableText.enumerateAttributes(in: fullTextRange, options: []) { attributes, range, stop in
            guard let currentFontSetter = attributes[AttributedStringView.FontSetterAttributeKey]
                as? FontSetter else {
                    fatalError("Could not read the FontSetter being enumerated over")
            }

            let determinedFont = currentFontSetter()
            print("New font size (\(determinedFont.pointSize.description)) in range \(range)")
            mutableText.addAttributes([.font : determinedFont], range: range)
        }

        /// Assign the new, updated formatted string
        display.attributedText = mutableText
    }
}
