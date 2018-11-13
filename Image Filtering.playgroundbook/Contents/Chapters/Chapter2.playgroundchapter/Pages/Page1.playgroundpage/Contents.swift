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
 # The Box filter
 
 On the previous page, you've learned about one of the most fundamental operations in digital signal processing, the convolution and how we can use the convolution to apply image filters.
 In this chapter and the following chapters, you'll learn about popular image filters. You already have seen one of them in the previous chapter.
 
 The box filter:
*/
let boxFilter: Kernel = .box(size: 9)
/*:
 The Box filter averages the neighbouring pixel values which results in a blurring effect
*/
let image = #imageLiteral(resourceName:"Camel.jpg")
let convolvedImage = image.convolve(with: boxFilter)
/*:
 Use `display(image: UIImage?)` to display an image and it's [Histogram](glossary://Histogram). You can display up to three images to compare between them
 * Note:
    You can drag and pinch in the Histogram to see all perspectives
 */
display(image: image)
display(image: convolvedImage)
/*: 
 * experiment:
    Play around with the parameters of the kernel and see how the result changes, but make sure that you are choosing an odd kernel size
 */
