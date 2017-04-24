//#-hidden-code
import UIKit
import PlaygroundSupport

PlaygroundPageSessionManager.shared.setup()
PlaygroundPage.current.needsIndefiniteExecution = true

var startedConvolution = false
//#-end-hidden-code
/*: Convolution Introduction
 # Introduction to Images, Filters & Convolution
 ## Images
 
 A digital *Image* raw representation is a two-dimensional matrix of color values like the 🦄 below.
 
 * Note:
    This Playground uses quadratic-sized matrices which can be described by an one-dimensional Array
 */
//#-code-completion(bookauxiliarymodule, hide)
//#-code-completion(identifier, hide, startedConvolution)
typealias Image = [UIColor]

let 🦄: Image = [
    //#-editable-code
    #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1),
    #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1),#colorLiteral(red: 0.968627452850342, green: 0.780392169952393, blue: 0.345098048448563, alpha: 1.0),
    #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1),#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1),#colorLiteral(red: 0.960784316062927, green: 0.705882370471954, blue: 0.200000002980232, alpha: 1.0),
    #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.968627452850342, green: 0.780392169952393, blue: 0.345098048448563, alpha: 1.0),#colorLiteral(red: 0.968627452850342, green: 0.780392169952393, blue: 0.345098048448563, alpha: 1.0),#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
    #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
    #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
    #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
    #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
    #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
    #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
    #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
    #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
    #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
    #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
    #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    //#-end-editable-code
    ]
/*:
 
 ## Filter
 
A *filter* or also called *kernel* is a matrix that describes a transformation process from one image to another with the following attributes
 1. The matrix must have an odd size
 2. If all values sum to one, the brightness doesn't change
 3. If the sum of all values are greater than one, the image gets brighter and darker if the sum is less than one
*/
typealias Kernel = [Float]

let filter: Kernel = [/*#-editable-code*/1/9/*#-end-editable-code*/,/*#-editable-code*/1/9/*#-end-editable-code*/,/*#-editable-code*/1/9/*#-end-editable-code*/,
                      /*#-editable-code*/1/9/*#-end-editable-code*/,/*#-editable-code*/1/9/*#-end-editable-code*/,/*#-editable-code*/1/9/*#-end-editable-code*/,
                      /*#-editable-code*/1/9/*#-end-editable-code*/,/*#-editable-code*/1/9/*#-end-editable-code*/,/*#-editable-code*/1/9/*#-end-editable-code*/]

//#-hidden-code

as [Float] // Workaround to improve the compile time. Radar filed: https://bugs.swift.org/browse/SR-4392

/// Starts the convolution 🙃
func startConvolution() {
    startedConvolution = true
    let hexValues = 🦄.asHexArray.map{ PlaygroundValue.integer($0) }
    let kernelValues = filter.map{ PlaygroundValue.floatingPoint(Double($0)) }
    
    let dict = PlaygroundValue.dictionary([Constants.imageKey: PlaygroundValue.array(hexValues),
                                           Constants.kernelKey: PlaygroundValue.array(kernelValues)])
        
    PlaygroundPage.current.proxy?.send(dict)
}
//#-end-hidden-code
/*:
 
 
 ## Convolution
 
 A *convolution* is a mathematical operation with two *signals* **f** and **g** which results in a modified version of **f**

 
 ![The Convolution Formula](ConvolutionEquation.png)
 
 
 At first glance, you're probably wondering what this operation has to do with image filtering.
 Well, our image and our filter are both signals and a convolution is a generic operation to apply any [linear](glossary://Linearity) filter to an Image
 
 
 ![The Convolution Formula](ConvolutionEquationEmojified.png)
 
 
 Don't worry if these math signs look like 🔮 to you!
 
 This equation states the following steps for each pixel in an Image:
 
1. Shift the center of the flipped filter kernel (x-τ) to the current pixel
2. Multiply all kernel values with the underlying values of the original image
3. The result pixel value is a sum of the multiplied values from step 2

  The convolution requires pixels that are outside of the image bounds. There are several methods to handle these unknown pixels. The implementation for this book ignores all values where the kernel covers unknown pixels which may lead to darker pixels at the border.
 

 🤷🏾‍♂️🤷‍♀️ Still confusing?

enter `startConvolution()` below and let's see how it works
 
 * Note:
 You can hold and drag to control the convolution and to see the exact calculation for each pixel
*/

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, startConvolution())
//#-editable-code Tap to enter code

//#-end-editable-code

//#-hidden-code
if !startedConvolution {
    PlaygroundPage.current.assessmentStatus = .fail(hints: ["You didn't start the convolution"], solution: "Enter `startConvolution()` and try it again")
}
//#-end-hidden-code
