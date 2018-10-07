import UIKit

extension Int {
    public func asPoint(totalWidth: Int) -> CGPoint {
        return CGPoint(x: Int(self % totalWidth), y: Int(self / totalWidth))
    }

    public func draw(in rect: CGRect, fontFactor: CGFloat = 2) {
        let font = UIFont.boldSystemFont(ofSize: rect.height / fontFactor).monospacedDigitFont
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.paragraphStyle: paragraph,
        ]
        NSAttributedString(string: "\(self)", attributes: attributes).draw(in: CGRect(origin: CGPoint(x: rect.origin.x, y: rect.origin.y + rect.height / 2 - font.lineHeight / 2), size: rect.size))
    }
}
