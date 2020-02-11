import UIKit

public class DrawingView: UIView {
    public var contentWidth: CGFloat = 1

    var drawingColors: [UIColor] {
        return []
    }

    public var showPixelBorder = false
    var pixelBorderColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
    var pixelBorderWidth: CGFloat = 1

    public var l_frame: CGRect {
        set {
            frame = newValue
            setPixelSizeToFit(width: frame.width)
        }

        get {
            return frame
        }
    }

    public func setPixelSizeToFit(width: CGFloat) {
        pixelSize = CGFloat(Int(width / contentWidth))
    }

    func updateSize() {
        let size = contentWidth * pixelSize
        frame = CGRect(origin: frame.origin, size: CGSize(width: size, height: size))
    }

    public var pixelSize: CGFloat = 10 {
        didSet {
            updateSize()
        }
    }

    public override func draw(_: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let size = CGSize(width: pixelSize, height: pixelSize)

        pixelBorderColor.setStroke()
        context?.setLineWidth(pixelBorderWidth)

        drawingColors.enumerated().forEach { index, color in
            color.setFill()
            let currentPoint = index.asPoint(totalWidth: Int(contentWidth))

            let currentRect = CGRect(origin: CGPoint(x: currentPoint.x * pixelSize, y: currentPoint.y * pixelSize), size: size)
            context?.fill(currentRect)

            if showPixelBorder {
                context?.stroke(currentRect)
            }
        }
    }
}
