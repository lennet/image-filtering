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
 # Laplacian of Gaussian
    
 While the Sobel operator only works in a particular direction, there are also alternative kernels that take the derivation of all directions into account. One of them is the Laplacian of Gaussian filter which is a combination of the [Laplacian operator](glossary://Laplace%20operator) and Gaussian distribution functions and therefore uses similar parameters as the Gaussian filter.
 
 ![Laplcian of Gaussian plot](laplacianofgaussian.png)
*/
let kernelSize = 27
let stdDeviation: Float = kernelSize/6
let loGFilter: Kernel = .laplacianOfGaussian(size: kernelSize, sigma: stdDeviation)

let image = #imageLiteral(resourceName:"Akropolis.jpg")
let convolvedImage = image.convolve(with: loGFilter)
display(image: image)
display(image: convolvedImage)
/*:
 * experiment:
 Apply a blurring filter before applying an Laplacian of Gaussian kernel and see how the result changes
 */


