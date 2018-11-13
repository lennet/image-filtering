import UIKit

public struct RGBValue {
    var red: Float
    var green: Float
    var blue: Float

    var asString: String {
        return "(\(String(format: "%.2f", red)),\(String(format: "%.2f", green)),\(String(format: "%.2f", blue)))"
    }
}

public struct CalculationStep {
    var imageValue: RGBValue
    var kernel: Float
    var result: RGBValue
}

extension UIColor {
    public convenience init(value: RGBValue) {
        self.init(red: CGFloat(value.red), green: CGFloat(value.green), blue: CGFloat(value.blue), alpha: 1)
    }
}

public class CalculationView: UIView {
    public var steps: [CalculationStep] = []
    public var result: RGBValue

    var lineHeight: CGFloat {
        return font.lineHeight + 10
    }

    var minFont: UIFont {
        return UIFont.boldSystemFont(ofSize: minFontSize).monospacedDigitFont
    }

    var font: UIFont {
        return UIFont.boldSystemFont(ofSize: fontSize).monospacedDigitFont
    }

    var colorSize: CGFloat {
        return font.lineHeight
    }

    var totalHeight: CGFloat {
        return CGFloat(steps.count + 2) * lineHeight
    }

    var yOffset: CGFloat {
        return (size.height - totalHeight) / 2
    }

    var fullSizeMode: Bool {
        // TODO: calculate the real value instead of guessing
        return size.width > 200
    }

    var minLineWidth: CGFloat {
        // TODO: improve minLineWidth calculation
        return minFont.pointSize * (fullSizeMode ? 30 : 20)
    }

    let minFontSize: CGFloat = 12

    var fontSize: CGFloat {
        return (size.width / minLineWidth) * minFontSize
    }

    var xOffset: CGFloat {
        return max(10, fontSize)
    }

    var stringAttributes: [NSAttributedString.Key: Any] {
        return [.font: font]
    }

    var maxX: CGFloat = 0

    public init(steps: [CalculationStep], result: RGBValue, frame: CGRect) {
        self.steps = steps
        self.result = result
        super.init(frame: frame)
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        maxX = 0
        steps.enumerated().forEach(draw)
        drawDivider()
        draw(result: result)
    }

    func draw(index: Int, step: CalculationStep) {
        let xMargin: CGFloat = 3

        let currentYValue = CGFloat(index) * lineHeight + yOffset
        var currentXValue = xOffset

        if fullSizeMode {
            let location = CGPoint(x: currentXValue, y: currentYValue)
            let attributedString = NSAttributedString(string: step.imageValue.asString, attributes: stringAttributes)
            attributedString.draw(at: location)
            let stringSize = attributedString.size()
            currentXValue += stringSize.width + xMargin
        }

        let color = UIColor(value: step.imageValue)
        let colorLocation = CGPoint(x: currentXValue, y: currentYValue + 1)
        draw(color: color, point: colorLocation)
        currentXValue += colorSize + 5

        let xLocation = CGPoint(x: currentXValue, y: currentYValue)
        let xAttributedString = NSAttributedString(string: "x", attributes: stringAttributes)
        xAttributedString.draw(at: xLocation)
        let xSize = xAttributedString.size()
        currentXValue += xSize.width + xMargin

        let attributedKernelResultString = NSAttributedString(string: "\(step.kernel.asFractionString) = \(step.result.asString)", attributes: stringAttributes)
        let kernelValueLocation = CGPoint(x: currentXValue, y: currentYValue)
        attributedKernelResultString.draw(at: kernelValueLocation)
        let kernelValueSize = attributedKernelResultString.size()
        currentXValue += kernelValueSize.width + xMargin

        let resultColor = UIColor(value: step.result)
        let resultColorLocation = CGPoint(x: currentXValue, y: currentYValue + 1)
        draw(color: resultColor, point: resultColorLocation)

        maxX = max(maxX, resultColorLocation.x + colorSize)
    }

    func drawDivider() {
        // draw divider
        let lineLocation = CGPoint(x: 0, y: CGFloat(steps.count) * lineHeight + yOffset)
        let linePath = UIBezierPath()
        linePath.addLine(from: lineLocation, to: CGPoint(x: maxX + xOffset, y: lineLocation.y))
        UIColor.black.setStroke()
        linePath.stroke()

        // draw +
        let plusLocation = CGPoint(x: xOffset / 3, y: lineLocation.y - CGFloat(lineHeight))
        NSAttributedString(string: "+", attributes: stringAttributes).draw(at: plusLocation)
    }

    func draw(result: RGBValue) {
        let location = CGPoint(x: xOffset, y: CGFloat(steps.count) * lineHeight + 10 + yOffset)

        let attributedString = NSAttributedString(string: result.asString, attributes: stringAttributes)
        attributedString.draw(at: location)
        let stringSize = attributedString.size()

        let color = UIColor(value: result)
        let colorLocation = CGPoint(x: location.x + stringSize.width + 5, y: location.y + 1)
        draw(color: color, point: colorLocation)
    }

    func draw(color: UIColor, point: CGPoint) {
        let colorRect = CGRect(origin: point, size: CGSize(width: colorSize, height: colorSize))
        let colorPath = UIBezierPath(roundedRect: colorRect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 1, height: 1))

        color.setFill()
        UIColor.black.setStroke()
        colorPath.stroke()
        colorPath.fill()
    }
}
