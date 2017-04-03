import UIKit

public class ImageView: DrawingView {

    public var image: [UIColor]
    
    override var drawingColors: [UIColor] {
        return image
    }

    public init(image: [UIColor]) {
        self.image = image
        super.init(frame: .zero)
        self.contentWidth = CGFloat(Int(sqrt(Double(self.image.count))))
        updateSize()
        
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

