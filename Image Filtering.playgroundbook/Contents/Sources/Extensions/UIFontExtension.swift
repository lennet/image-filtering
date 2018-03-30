import UIKit

extension UIFont {
    public var monospacedDigitFont: UIFont {
        let fontDescriptorFeatureSetting = [UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType, UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector]
        let monospacedFontDescriptor = fontDescriptor.addingAttributes([UIFontDescriptor.AttributeName.featureSettings: [fontDescriptorFeatureSetting]])
        return UIFont(descriptor: monospacedFontDescriptor, size: pointSize)
    }
}
