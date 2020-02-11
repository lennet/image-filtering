import PlaygroundSupport
import UIKit

extension CompareImagesViewController: PlaygroundLiveViewMessageHandler {
    public func receive(_ message: PlaygroundValue) {
        switch message {
        case let .string(message):
            guard message == Constants.resetKey else {
                return
            }

            reset()
        case let .data(messageValue):
            guard let image = UIImage(data: messageValue) else {
                return
            }
            addImage(image: image)
        default:
            break
        }
    }

    public class func setupAsLiveView() {
        let vc = CompareImagesViewController()
        vc.view.backgroundColor = .white
        PlaygroundPage.current.liveView = vc
        PlaygroundPage.current.needsIndefiniteExecution = true
    }
}
