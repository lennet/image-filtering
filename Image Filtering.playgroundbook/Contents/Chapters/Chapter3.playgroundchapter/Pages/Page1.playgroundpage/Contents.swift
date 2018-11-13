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
 # Sobel operator
 
 [Edge detection](glossary://Edge%20detector) is an important component of image processing which is also used in many machine learning algorithms.
 
 One famous method to detect edges is the Sobel operator:
 */
let sobelFilter: Kernel = .sobel(direction: .left)
/*:
 The Sobel operator calculates the derivation of the intensity values in a given direction
 */
let image = #imageLiteral(resourceName:"Staircase.jpg")
let convolvedImage = image.convolve(with: sobelFilter)

display(image: image)
display(image: convolvedImage)
/*:
 * experiment:
 Convert your image to a Grayscale-Image with `image.AsGrayScaleImage` before applying the Sobel operator and see how the result changes
 */


