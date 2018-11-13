import UIKit
import PlaygroundSupport

let vc = ConvolutionDemoViewController()
vc.displayImage(hexValues: PlaygroundStore.hex🦄)

PlaygroundPage.current.liveView = vc
PlaygroundPage.current.needsIndefiniteExecution = true

extension ConvolutionDemoViewController: PlaygroundLiveViewMessageHandler {

    public func liveViewMessageConnectionClosed() {
        UIView.setAnimationsEnabled(false)
        reset()
        vc.displayImage(hexValues: PlaygroundStore.hex🦄)
        UIView.setAnimationsEnabled(true)
        PlaygroundPage.current.finishExecution()
    }


    public func receive(_ message: PlaygroundValue) {

        guard case let .dictionary(messageValue) = message else {
            return
        }

        guard case let .array(hexPlaygroundValues)? = messageValue[Constants.imageKey] else {
            return
        }

        guard case let .array(kernelPlaygroundValue)? = messageValue[Constants.kernelKey] else {
            return
        }

        let hexValues: [Int] = hexPlaygroundValues.compactMap {
            if case let .integer(value) = $0 {
                return value
            }
            return nil
        }

        guard validQuadraticInput(input: hexValues) else {
            PlaygroundLiveViewSessionManager.shared.sendError(hint:"The imagesize isn't quadratic", solution: "You can reset the page to get the original image")
            return
        }

        let kernelValues: [Float] = kernelPlaygroundValue.compactMap {
            if case let .floatingPoint(value) = $0 {
                return Float(value)
            }
            return nil
        }

        guard validQuadraticInput(input: kernelValues) else {
            PlaygroundLiveViewSessionManager.shared.sendError(hint:"The filter kernel isn't quadratic", solution: "You can reset the page to get the original kernel")
            return
        }

        reset()

        PlaygroundStore.hex🦄 = hexValues
        displayImage(hexValues: hexValues)
        convolve(with: kernelValues)
    }

    func validQuadraticInput(input: [Any]) -> Bool {
        return Int(pow(Double(Int(sqrt(Double(input.count)))),2)) == input.count

    }

}

