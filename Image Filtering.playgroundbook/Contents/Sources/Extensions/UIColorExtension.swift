import UIKit

extension UIColor {
    public var components: (red: Float, green: Float, blue: Float, alpha: Float) {
        let cgColor = self.cgColor
        let comps = cgColor.components
        switch cgColor.numberOfComponents {
        case 2:
            return (red: Float(comps![0]), green: Float(comps![0]), blue: Float(comps![0]), alpha: Float(comps![1]))
        case 4:
            return (red: Float(comps![0]), green: Float(comps![1]), blue: Float(comps![2]), alpha: Float(comps![3]))
        default:
            break
        }
        return (red: 0, green: 0, blue: 0, alpha: 0)
    }

    public convenience init(hexValue: Int) {
        let red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hexValue & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(hexValue & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }

    public var hexValue: Int {
        return (Int)(components.red * 255) << 16 | Int(components.green * 255) << 8 | Int(components.blue * 255) << 0
    }
}

extension Array where Element == UIColor {
    public var asHexArray: [Int] {
        return map { $0.hexValue }
    }
}
