import UIKit

public enum Interpolation {
    case none
    case linear
}

extension UIBezierPath {
    public convenience init(points: [CGPoint], interpolation: Interpolation) {
        self.init()
        switch interpolation {
        case .none:
            points.forEach {
                addLine(from: CGPoint(x: $0.x, y: 0), to: $0)
            }
        case .linear:
            move(to: .zero)
            points.forEach { addLine(to: $0) }
        }
    }

    public func addLine(from: CGPoint, to: CGPoint) {
        move(to: from)
        addLine(to: to)
    }
}
