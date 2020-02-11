import CoreGraphics
import Foundation

let pi: Float = Float(CGFloat.pi)

public enum Direction {
    case left
    case top
    case right
    case bottom
}

public enum Kernel {
    /// The Laplacian of Gaussian is a combination of the Laplacian operator and Gaussian distribution functions which detect points/ edges in all directions
    /// - parameter size: The size of the filter kernel. **Must be odd**
    /// - parameter sigma: The standard derivation of the distribution function
    case laplacianOfGaussian(size: Int, sigma: Float)
    /// The Sobel operator is an edge detector which calculates the derivation of the intensity values in a given direction
    /// - parameter direction: The direction of the derrivation function
    case sobel(direction: Direction)
    /// The Sharpener filter enhances the difference the current pixel, and it's adjacent pixels which increase the perceived sharpness
    case sharpener
    /// The Gaussian-Filter is a blurring filter which uses an implementation of the Gaussian distribution function which has it's biggest values in the center and decreases depending on the standard derivation variable sigma
    /// - parameter size: The size of the filter kernel. **Must be odd**
    /// - parameter sigma: The standard derivation of the distribution function
    case gaussian(size: Int, sigma: Float)
    /// The Emboss filter creates an embossing effect by replacing each pixel with highlight or shadow, depending on derivation of the current region
    case emboss
    /// The Box filter calculates the average value of the neighboring pixels which blurs the image. The number of pixels that are taken into account depends on  the filter size
    /// - parameter size: The size of the filter kernel. **Must be odd**
    case box(size: Int)
    /// The identity filter doesn't change the original image
    case identity
    /// A custom valus
    /// - parameter values: The values of you custom kernel. The number of elements **must be odd**
    case custom(values: [Float])

    public var rawValue: [Float] {
        switch self {
        case let .laplacianOfGaussian(size, sigma):
            let totalLength = size * size
            let mean: Float = ceil(Float(size) / 2.0)
            let squaredSigma: Float = pow(sigma, 2)
            let fixedWeight = 1.0 / (pi * pow(squaredSigma, 2))
            var sum: Float = 0
            let unnormalizedLaplacian: [Float] = (1 ... totalLength).map { x in
                let point = x.asPoint(totalWidth: size)
                let rad = (pow(Float(point.x) - mean, 2) + pow(Float(point.y + 1) - mean, 2)) / (2 * squaredSigma)

                let result = -fixedWeight * (1 - rad) * exp(-rad)
                sum += abs(result)
                return result
            }

            return unnormalizedLaplacian.map { $0 / abs(sum) }
        case let .sobel(direction):
            switch direction {
            case .left:
                return [1, 0, -1, 2, 0, -2, 1, 0, -1]
            case .top:
                return [1, 2, 1, 0, 0, 0, -1, -2, -1]
            case .right:
                return [-1, 0, 1, -2, 0, 2, -1, 0, 1]
            case .bottom:
                return [-1, -2, -1, 0, 0, 0, 1, 2, 1]
            }
        case .sharpener:
            return [0, -1, 0, -1, 5, -1, 0, -1, 0]
        case let .gaussian(size, sigma):
            let totalLength = size * size
            let mean: Float = ceil(Float(size) / 2.0)
            let squaredSigma: Float = pow(sigma, 2)
            let fixedWeight = 1.0 / (2.0 * pi * squaredSigma)
            var sum: Float = 0
            let unnormalizedGaussian: [Float] = (1 ... totalLength).map { x in
                let point = x.asPoint(totalWidth: size)
                let rad = (pow(Float(point.x) - mean, 2) + pow(Float(point.y + 1) - mean, 2)) / (2 * squaredSigma)

                let result = fixedWeight * exp(-rad)
                sum += result
                return result
            }

            return unnormalizedGaussian.map { $0 / sum }
        case .emboss:
            return [-1, -1, 0, -1, 0, 1, 0, 1, 1]
        case let .box(size):
            let totalLength = size * size
            return (1 ... totalLength).map { _ in Float(1) / Float(totalLength) }
        case .identity:
            return [0, 0, 0, 0, 1, 0, 0, 0, 0]
        case let .custom(values: value):
            return value
        }
    }

    public var size: Int {
        return Int(ceil(sqrt(Double(rawValue.count))))
    }
}

extension Kernel: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        let kernelView = KernelView(kernel: rawValue)
        kernelView.backgroundColor = .white
        kernelView.setPixelSizeToFit(width: 200)
        kernelView.renderMode = .matrice
        return kernelView
    }
}
