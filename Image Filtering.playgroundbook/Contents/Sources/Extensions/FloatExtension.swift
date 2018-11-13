import UIKit

extension Float {
    public func draw(in rect: CGRect) {
        let fraction = Fraction(value: Double(self))
        if fraction.den != 1 {
            fraction.draw(in: rect)
        } else {
            fraction.num.draw(in: rect)
        }
    }

    public var asFractionString: String {
        let fraction = Fraction(value: Double(self))
        if fraction.den != 1 {
            return "\(fraction.num)/\(fraction.den)"
        } else {
            return "\(fraction.num)"
        }
    }

    public static func / (left: Int, right: Float) -> Float {
        return Float(left) / right
    }
}
