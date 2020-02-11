import MetalKit
import MetalPerformanceShaders
import PlaygroundSupport

// this extension uses fatalError instead of thworing errors becuase they are getting displayed inline in Swift Playground on iPad

extension UIImage {
    /// Convolves the image with a filter kernel
    /// - Complexity: Depends on the Image and Kernel size but as it uses MetalPerformanceShaders 🤘 the operation is stil fast
    /// - parameter kernel: The kernel you want to convove the image with
    /// - returns: the transformed image but may also throw an fatalError for even filterkernel sizes or for devices that doesn't support Metal
    public func convolve(with kernel: Kernel) -> UIImage {
        let size = Int(sqrt(Double(kernel.rawValue.count)))
        guard size % 2 == 1 else {
            PlaygroundPageSessionManager.shared.showErrorMessage(hint: "The size of the filter kernel must be odd. Change it to an odd number like 9,27 or 49", solution: nil)
            fatalError("The size of the filter kernel must be odd. Change it to an odd number like 9,27 or 49")
        }
        return convolve(with: kernel.rawValue)
    }

    func convolve(with kernel: [Float]) -> UIImage {
        guard let cgImage = cgImage else {
            PlaygroundPageSessionManager.shared.showErrorMessage(hint: "Oops! Something went wrong. Please start the convolution again", solution: nil)
            fatalError("Oops! Something went wrong. Please start the convolution again")
        }
        guard let device = MTLCreateSystemDefaultDevice() else {
            PlaygroundPageSessionManager.shared.showErrorMessage(hint: "Oops! Your device doesn't support Metal", solution: nil)
            fatalError("Oops! Your device doesn't support Metal")
        }
        let queue = device.makeCommandQueue()
        let kernelSize = Int(ceil(sqrt(Double(kernel.count))))

        let shader = MPSImageConvolution(device: device, kernelWidth: kernelSize, kernelHeight: kernelSize, weights: kernel)
        shader.edgeMode = .zero

        let textureLoader = MTKTextureLoader(device: device)

        let texture: MTLTexture
        do {
            texture = try textureLoader.newTexture(cgImage: cgImage, options: nil)
        } catch {
            PlaygroundPageSessionManager.shared.showErrorMessage(hint: "Oops! Something went wrong. Please start the convolution again", solution: nil)
            fatalError("Oops! Something went wrong. Please start the convolution again")
        }

        let descriptor = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: texture.pixelFormat,
            width: texture.width,
            height: texture.height,
            mipmapped: false
        )
        descriptor.usage = [.shaderWrite, .shaderRead]

        guard let destination: MTLTexture = device.makeTexture(descriptor: descriptor) else {
            PlaygroundPageSessionManager.shared.showErrorMessage(hint: "Oops! Something went wrong. Please start the convolution again", solution: nil)
            fatalError("Oops! Something went wrong. Please start the convolution again")
        }

        guard let commandBuffer = queue?.makeCommandBuffer() else {
            PlaygroundPageSessionManager.shared.showErrorMessage(hint: "Oops! Something went wrong. Please start the convolution again", solution: nil)
            fatalError("Oops! Something went wrong. Please start the convolution again")
        }

        shader.encode(commandBuffer: commandBuffer, sourceTexture: texture, destinationTexture: destination)

        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()

        if let error = commandBuffer.error as? MTLCommandBufferError {
            switch error.code {
            case .timeout:
                PlaygroundPageSessionManager.shared.showErrorMessage(hint: "Oops! The execution of the convolution took too long. Please select a smaller kernel size or a smaller image", solution: nil)
                fatalError("Oops! The execution of the convolution took too long. Please select a smaller kernel size or a smaller image")
            default:
                PlaygroundPageSessionManager.shared.showErrorMessage(hint: "Oops! Something went wrong. Please start the convolution again", solution: nil)
                fatalError("Oops! Something went wrong. Please start the convolution again")
            }
        }

        return UIImage(texture: destination)
    }

    convenience init(texture: MTLTexture) {
        let byteCount = texture.width * texture.height * 4

        guard let imageBytes = malloc(byteCount) else {
            PlaygroundPageSessionManager.shared.showErrorMessage(hint: "Oops! Something went wrong. Please start the convolution again", solution: nil)
            fatalError("Oops! Something went wrong. Please start the convolution again")
        }
        let bytesPerRow = texture.width * 4
        let region = MTLRegionMake2D(0, 0, texture.width, texture.height)
        texture.getBytes(imageBytes, bytesPerRow: bytesPerRow, from: region, mipmapLevel: 0)

        let freeDataCallBack: CGDataProviderReleaseDataCallback = { (_: UnsafeMutableRawPointer?, _: UnsafeRawPointer, _: Int) -> Void in
        }

        guard let dataProvider = CGDataProvider(dataInfo: nil, data: imageBytes, size: byteCount, releaseData: freeDataCallBack) else {
            PlaygroundPageSessionManager.shared.showErrorMessage(hint: "Oops! Something went wrong. Please start the convolution again", solution: nil)
            fatalError("Oops! Something went wrong. Please start the convolution again")
        }

        let bitsPerComponent = 8
        let bitsPerPixel = 32

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.noneSkipFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue

        let renderingIndent = CGColorRenderingIntent.defaultIntent

        guard let image = CGImage(width: texture.width, height: texture.height, bitsPerComponent: bitsPerComponent, bitsPerPixel: bitsPerPixel, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGBitmapInfo(rawValue: bitmapInfo), provider: dataProvider, decode: nil, shouldInterpolate: true, intent: renderingIndent) else {
            PlaygroundPageSessionManager.shared.showErrorMessage(hint: "Oops! Something went wrong. Please start the convolution again", solution: nil)
            fatalError("Oops! Something went wrong. Please start the convolution again")
        }

        self.init(cgImage: image)
    }
}
