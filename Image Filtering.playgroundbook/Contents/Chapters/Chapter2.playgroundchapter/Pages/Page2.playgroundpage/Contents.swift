//#-hidden-code
import UIKit
import PlaygroundSupport

PlaygroundPageSessionManager.shared.resetAssesmentStatus()

var displayedImageCount = 0

/// Display's an image and it's Histogram. You can display up to three images to compare between them
/// - parameter image: The image you want to display
func display(image: UIImage) {
    guard displayedImageCount < 3 else {
        PlaygroundPageSessionManager.shared.showErrorMessage(hint: "You can only display up to three images", solution: nil)
        return
    }
    
    guard let data = image.jpegData(compressionQuality: 1) else {
        return
    }
    
    let message = PlaygroundValue.data(data)
    PlaygroundPage.current.proxy?.send(message)
    
    displayedImageCount += 1
}

PlaygroundPage.current.proxy?.send(.string(Constants.resetKey))

extension Float {
 
    public static func /(left: Int, right: Float) -> Float {
        return Float(left)/right
    }
    
}

//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, hide, displayedImageCount)
//#-code-completion(literal, show, image, color)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, true, false, &&, ||, !, *, /, (, ))
//#-code-completion(identifier, show, UIImage, convolve(with:_), asGrayScaleImage)
//#-code-completion(identifier, show, Kernel, laplacianOfGaussian(size:sigma:), box(size:_), gaussian(size:sigma:), sobel(direction:_), sharpener, custom(values:_), identity, emboss)
//#-code-completion(identifier, show, Direction, left, right, top, bottom)
//#-end-hidden-code
/*:
 # The Gaussian filter
 
 The Box filter is easy to implement but often doesn't give the best possible result because of its rectangular shape, and the same weights for all values which can lead to artifacts. Another smoothing/blurring filter which doesn't have these problems is the Gaussian filter or also known as Gaussian blur:
*/
let kernelSize = 27
let stdDeviation: Float = kernelSize/5
let gaussianFilter: Kernel = .gaussian(size: kernelSize, sigma: stdDeviation)
/*:
 The Gaussian filter is an implementation of the [Gaussian distribution function](glossary://Gaussian%20distribution) which has it's biggest values in the center and decreases depending on the standard deviation variable sigma.
 
 ![Gaussian plot](gaussian.png)
 * Note:
    Debug-quicklooks might help to get a better understanding of a filter kernel. Tap one the icon next to your kernel variable after you've run the playground once to get a numeric representation or visual representation for filter kernel which have a kernel size of greater than 9
*/
let image = #imageLiteral(resourceName:"Elephants.jpg")
let convolvedImage = image.convolve(with: gaussianFilter)

display(image: image)
display(image: convolvedImage)
/*:
 * experiment:
    Use display(image: UIImage?)` to compare your results with an image that has been convolved with an Box filter
 */
