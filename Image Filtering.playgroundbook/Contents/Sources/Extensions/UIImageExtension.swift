import Accelerate
import UIKit

public typealias HistogramData = (red: [vImagePixelCount], blue: [vImagePixelCount], green: [vImagePixelCount], alpha: [vImagePixelCount])

extension UIImage {
    public func getHistogramValues() -> HistogramData {
        guard let cgImage = cgImage else {
            return (red: [], green: [], blue: [], alpha: [])
        }

        var format = vImage_CGImageFormat(
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            colorSpace: nil,
            bitmapInfo: CGBitmapInfo(
                rawValue: CGImageAlphaInfo.premultipliedLast.rawValue
            ),
            version: 0,
            decode: nil,
            renderingIntent: .defaultIntent
        )

        var inBuffer: vImage_Buffer = vImage_Buffer()

        vImageBuffer_InitWithCGImage(
            &inBuffer,
            &format,
            nil,
            cgImage,
            UInt32(kvImageNoFlags)
        )

        let red = [vImagePixelCount](repeatElement(0, count: 256))
        let green = [vImagePixelCount](repeatElement(0, count: 256))
        let blue = [vImagePixelCount](repeatElement(0, count: 256))
        let alpha = [vImagePixelCount](repeatElement(0, count: 256))

        let histogram = UnsafeMutablePointer<UnsafeMutablePointer<vImagePixelCount>?>.allocate(capacity: 4)
        histogram[0] = UnsafeMutablePointer<vImagePixelCount>(mutating: red)
        histogram[1] = UnsafeMutablePointer<vImagePixelCount>(mutating: green)
        histogram[2] = UnsafeMutablePointer<vImagePixelCount>(mutating: blue)
        histogram[3] = UnsafeMutablePointer<vImagePixelCount>(mutating: alpha)

        vImageHistogramCalculation_ARGB8888(&inBuffer, histogram, UInt32(kvImageNoFlags))

        free(inBuffer.data)

        return (red: red, green: green, blue: blue, alpha: alpha)
    }

    /// Turns a RGB - Image into a Grayscale (⬛️⬜️) - Image
    public var asGrayScaleImage: UIImage {
        let filter = CIFilter(name: "CIPhotoEffectMono")
        filter?.setValue(CIImage(image: self), forKey: "inputImage")

        let context = CIContext()
        let result = context.createCGImage((filter?.outputImage)!, from: filter!.outputImage!.extent)
        return UIImage(cgImage: result!)
    }
}
