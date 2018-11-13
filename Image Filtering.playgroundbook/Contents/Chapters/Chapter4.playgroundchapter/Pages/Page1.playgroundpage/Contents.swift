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
 # Filter Playground
 
 You've learned about some great Image filters. Now, it's time for you to get creative and design your own filter kernels
 
 Keep in mind that a filter kernel:
1. must have an odd size
2. brightens or darkens the image if all values some to greater or less than zero
 
 
 * Note:
 You can use Debug-quicklooks to get some inspiration from existing kernels
 
 */
let motionBlurKernelValues: [Float] =
    [1/9,0,0,0,0,0,0,0,0,
     0,1/9,0,0,0,0,0,0,0,
     0,0,1/9,0,0,0,0,0,0,
     0,0,0,1/9,0,0,0,0,0,
     0,0,0,0,1/9,0,0,0,0,
     0,0,0,0,0,1/9,0,0,0,
     0,0,0,0,0,0,1/9,0,0,
     0,0,0,0,0,0,0,1/9,0,
     0,0,0,0,0,0,0,0,1/9]

let customFilter: Kernel = .custom(values: motionBlurKernelValues)

let image = #imageLiteral(resourceName:"Studying.jpg")
let convolvedImage = image.convolve(with: customFilter)

display(image: image)
display(image: convolvedImage)
