import UIKit

struct Fraction {
    let num: Int
    let den: Int
}

extension Fraction {
    init(value: Double) {
        let precision = 1.0e-6
        var x = value
        var roundedX = x.rounded(.down)
        var tmpNum = 1
        var tmpDen = 0
        var num = Int(roundedX)
        var den = 1

        while x - roundedX > precision * pow(Double(den), 2) {
            x = 1 / (x - roundedX)
            roundedX = x.rounded(.down)
            (tmpNum, tmpDen, num, den) = (num, den, tmpNum + Int(roundedX) * num, tmpDen + Int(roundedX) * den)
        }
        self.init(num: num, den: den)
    }
}

extension Fraction {
    func draw(in rect: CGRect) {
        let line = UIBezierPath()
        line.lineWidth = rect.size.height / 22
        let lineMargin: CGFloat = rect.size.width / 3.5

        var lineOrigin = rect.origin
        lineOrigin.y += rect.height / 2 - line.lineWidth / 2
        lineOrigin.x += lineMargin

        line.addLine(from: lineOrigin, to: CGPoint(x: lineOrigin.x + rect.width - lineMargin * 2, y: lineOrigin.y))

        UIColor.black.setStroke()
        line.stroke()

        let valueSize = CGSize(width: rect.size.width, height: rect.size.height / 2)
        let numRect = CGRect(origin: rect.origin, size: valueSize)
        let denRect = CGRect(origin: CGPoint(x: rect.origin.x, y: lineOrigin.y + line.lineWidth), size: valueSize)

        num.draw(in: numRect, fontFactor: 1.5)
        den.draw(in: denRect, fontFactor: 1.5)
    }
}
