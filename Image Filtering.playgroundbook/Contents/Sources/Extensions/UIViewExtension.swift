import UIKit

extension UIView {

    public func addSubViewWithFadeAnimation(view: UIView, duration: TimeInterval = 0.75, completion: ((Bool) -> Void)? = nil) {
        view.alpha = 0
        addSubview(view)

        UIView.animate(withDuration: duration, animations: {
            view.alpha = 1
        }, completion: completion)
    }

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
