import Foundation
import PlaygroundSupport

public class PlaygroundPageSessionManager: PlaygroundRemoteLiveViewProxyDelegate {
    public static let shared = PlaygroundPageSessionManager()

    private init() {}

    public func setup() {
        PlaygroundPage.current.proxy?.delegate = self
    }

    public func remoteLiveViewProxy(_: PlaygroundRemoteLiveViewProxy, received message: PlaygroundValue) {
        guard case let .dictionary(messageValue) = message else {
            return
        }

        guard case let .boolean(isErrorMessage)? = messageValue[Constants.errorKey] else {
            return
        }

        if isErrorMessage {
            showErrorMessage(messageValue: messageValue)
        } else {
            showSuccessMessage(messageValue: messageValue)
        }
    }

    func showErrorMessage(messageValue: [String: PlaygroundValue]) {
        guard case let .string(solution)? = messageValue[Constants.solutionKey] else {
            return
        }

        guard case let .string(hint)? = messageValue[Constants.hintKey] else {
            return
        }

        showErrorMessage(hint: hint, solution: solution)
    }

    public func showErrorMessage(hint: String, solution: String?) {
        PlaygroundPage.current.assessmentStatus = .fail(hints: [hint], solution: solution)
    }

    public func resetAssesmentStatus() {
        PlaygroundPage.current.assessmentStatus = nil
    }

    func showSuccessMessage(messageValue: [String: PlaygroundValue]) {
        guard case let .string(passMessage)? = messageValue[Constants.passKey] else {
            return
        }

        PlaygroundPage.current.assessmentStatus = .pass(message: passMessage)
        PlaygroundPage.current.finishExecution()
    }

    public func remoteLiveViewProxyConnectionClosed(_: PlaygroundRemoteLiveViewProxy) {}
}
