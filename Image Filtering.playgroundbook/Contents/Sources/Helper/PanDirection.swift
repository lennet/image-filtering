import CoreGraphics

public enum PanDirection {
    case left
    case topLeft
    case top
    case topRight
    case right
    case bottomRight
    case bottom
    case bottomLeft
    case none

    public init(translation: CGPoint) {
        let minDistance: CGFloat = 10

        switch (translation.x, translation.y) {
        case let (x, y) where x > minDistance && y > minDistance:
            self = .topRight
        case let (x, y) where x < -minDistance && y < -minDistance:
            self = .bottomLeft
        case let (x, y) where x < -minDistance && y > minDistance:
            self = .topLeft
        case let (x, y) where x > minDistance && y < -minDistance:
            self = .bottomRight
        case let (x, _) where x > minDistance:
            self = .right
        case let (x, _) where x < -minDistance:
            self = .left
        case let (_, y) where y > minDistance:
            self = .top
        case let (_, y) where y < -minDistance:
            self = .bottom
        default:
            self = .none
        }
    }
}
