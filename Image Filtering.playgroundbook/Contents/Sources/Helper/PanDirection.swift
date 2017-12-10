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
            break
        case let (x, y) where x < -minDistance && y < -minDistance:
            self = .bottomLeft
            break
        case let (x, y) where x < -minDistance && y > minDistance:
            self = .topLeft
            break
        case let (x, y) where x > minDistance && y < -minDistance:
            self = .bottomRight
            break
        case let (x, _) where x > minDistance:
            self = .right
            break
        case let (x, _) where x < -minDistance:
            self = .left
            break
        case let (_, y) where y > minDistance:
            self = .top
            break
        case let (_, y) where y < -minDistance:
            self = .bottom
            break
        default:
            self = .none
            break
        }
    }
}
