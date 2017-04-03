import UIKit

extension UIFont {
    
    var monospacedDigitFont: UIFont {
        let fontDescriptorFeatureSetting = [UIFontFeatureTypeIdentifierKey: kNumberSpacingType, UIFontFeatureSelectorIdentifierKey: kMonospacedNumbersSelector]
        let monospacedFontDescriptor = fontDescriptor.addingAttributes([UIFontDescriptorFeatureSettingsAttribute: [fontDescriptorFeatureSetting]])
        return UIFont(descriptor: monospacedFontDescriptor, size: pointSize)
    }
    
}
