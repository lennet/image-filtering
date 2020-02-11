import UIKit

public class KernelView: DrawingView {
    let kernel: [Float]
    let colors: [UIColor]

    override var drawingColors: [UIColor] {
        return colors
    }

    public enum KernelRenderMode {
        case image
        case values
        case matrice
    }

    public var renderMode: KernelRenderMode = .values {
        didSet {
            setNeedsDisplay()
        }
    }

    public init(kernel: [Float]) {
        self.kernel = kernel

        // TODO: evaluating rendering negative values

        if let maxValue = kernel.max(),
            let min = kernel.min() {
            colors = kernel.map { value in
                if value > 0 {
                    return UIColor(white: 0, alpha: CGFloat(value / maxValue + abs(min)))
                } else {
                    return UIColor(red: 1, green: 0, blue: 0, alpha: CGFloat(value / min + (abs(maxValue) * -1)))
                }
            }
        } else {
            colors = []
        }

        super.init(frame: .zero)
        contentWidth = CGFloat(Int(sqrt(Double(kernel.count))))
        updateSize()
        backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }

    public required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func draw(_ rect: CGRect) {
        if pixelSize < 5 || kernel.count > 100 {
            // the pixelsize is too high for the rectSize and an image version is more readable then the matrice or values
            super.draw(rect)
            return
        }

        switch renderMode {
        case .image:
            super.draw(rect)
        case .values:
            drawValues(rect)
        case .matrice:
            drawMatrice(rect)
        }
    }

    func drawMatrice(_ rect: CGRect) {
        let parenthesisWidth: CGFloat = rect.width / 15
        let height = frame.size.height
        let width = frame.size.width

        let path = UIBezierPath()

        UIColor.white.setFill()

        // todo move everithing parenthesisWidth/2!

        path.addLine(from: .zero, to: CGPoint(x: parenthesisWidth, y: 0))
        path.addLine(from: .zero, to: CGPoint(x: 0, y: height))
        path.addLine(from: CGPoint(x: 0, y: height), to: CGPoint(x: parenthesisWidth, y: height))

        path.addLine(from: CGPoint(x: width, y: height), to: CGPoint(x: width - parenthesisWidth, y: height))
        path.addLine(from: CGPoint(x: width, y: height), to: CGPoint(x: width, y: 0))
        path.addLine(from: CGPoint(x: width, y: 0), to: CGPoint(x: width - parenthesisWidth, y: 0))

        path.lineWidth = parenthesisWidth

        path.stroke()

        let valuesRect = CGRect(x: parenthesisWidth / 2, y: parenthesisWidth / 2, width: rect.width - parenthesisWidth, height: rect.height - parenthesisWidth)

        drawValues(valuesRect)
    }

    func drawValues(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        let x: CGFloat = rect.origin.x
        let y: CGFloat = rect.origin.y

        let acutalPixelSize: CGFloat = rect.size.width / contentWidth

        pixelBorderColor.setStroke()
        context.setLineWidth(pixelBorderWidth)

        for (index, value) in kernel.enumerated() {
            let point = index.asPoint(totalWidth: Int(contentWidth))

            let drawRect = CGRect(origin: CGPoint(x: point.x * acutalPixelSize + x, y: point.y * acutalPixelSize + y), size: CGSize(width: acutalPixelSize, height: acutalPixelSize))

            if showPixelBorder {
                context.stroke(drawRect)
            }

            value.draw(in: drawRect)
        }
    }
}
