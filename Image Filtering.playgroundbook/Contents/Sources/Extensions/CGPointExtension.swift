import UIKit

extension CGPoint {
    public func asIndex(totalWidth: Int) -> Int {
        return Int(x) + totalWidth * Int(y)
    }
}
