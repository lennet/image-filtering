import UIKit

extension UIView {
    public var origin: CGPoint {
        get {
            return frame.origin
        }

        set {
            frame = CGRect(origin: newValue, size: frame.size)
        }
    }

    public var size: CGSize {
        get {
            return frame.size
        }

        set {
            frame = CGRect(origin: frame.origin, size: newValue)
        }
    }
}
