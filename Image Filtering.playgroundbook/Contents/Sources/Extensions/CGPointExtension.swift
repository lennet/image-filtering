import UIKit

extension CGPoint {

    public func asIndex(totalWidth: Int) -> Int {
        return Int(self.x)+totalWidth*Int(self.y)
    }
    
}

