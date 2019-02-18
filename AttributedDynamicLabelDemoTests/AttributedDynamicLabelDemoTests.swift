import XCTest
@testable import AttributedDynamicLabelDemo

class AttributedDynamicLabelDemoTests: XCTestCase {

    var subject: AttributedStringView!

    override func setUp() {
        super.setUp()
        subject = AttributedStringView()
    }

    func testAttributedStringDynamicType() {

        var extraSmallSizes: [CGFloat] = []
        var largeSizes: [CGFloat] = []
        var biggestSizes: [CGFloat] = []

        let fullTextRange = NSRange(location: 0,
                                    length: subject.display.attributedText!.string.count)

        /// Test extraSmall content size
        /// String 1: 14.8
        /// String 2: 6.6
        /// String 3: 14.8
        /// String 4: 39.5
        FontMetrics.default.sizeCategory = .extraSmall
        NSMutableAttributedString(attributedString: subject.display.attributedText!)
            .enumerateAttributes(in: fullTextRange,
                                 options: []) { attributes, range, stop in
                                    let gottenFont = attributes[.font] as! UIFont
                                    extraSmallSizes.append(gottenFont.pointSize)
        }

        /// Test large content size
        /// String 1: 18.0
        /// String 2: 8.0
        /// String 3: 18.0
        /// String 4: 48.0
        FontMetrics.default.sizeCategory = .large
        NSMutableAttributedString(attributedString: subject.display.attributedText!)
            .enumerateAttributes(in: fullTextRange,
                                 options: []) { attributes, range, stop in
                                    let gottenFont = attributes[.font] as! UIFont
                                    largeSizes.append(gottenFont.pointSize)
        }

        /// Test accessibilityExtraExtraExtraLarge content size
        /// String 1: 56.1
        /// String 2: 24.9
        /// String 3: 24.0
        /// String 4: 149.6
        FontMetrics.default.sizeCategory = .accessibilityExtraExtraExtraLarge
        NSMutableAttributedString(attributedString: subject.display.attributedText!)
            .enumerateAttributes(in: fullTextRange,
                                 options: []) { attributes, range, stop in
                                    let gottenFont = attributes[.font] as! UIFont
                                    biggestSizes.append(gottenFont.pointSize)
        }

        for (index, smallSize) in extraSmallSizes.enumerated() {
            XCTAssert(smallSize < largeSizes[index])
            XCTAssert(largeSizes[index] < biggestSizes[index])
        }
    }
}


