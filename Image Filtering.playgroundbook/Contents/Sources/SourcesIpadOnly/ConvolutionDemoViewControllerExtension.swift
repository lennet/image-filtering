import UIKit
import PlaygroundSupport

extension ConvolutionDemoViewController {

    public func showSuccessMessage() {
        PlaygroundLiveViewSessionManager.shared.sendPassMessage(message: "Yeah! You successfully convolved the image with a filter kernel. Proceed to the next pages to learn about different filters and how they work")
    }

}
