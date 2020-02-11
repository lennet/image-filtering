import Foundation
import PlaygroundSupport

public class PlaygroundLiveViewSessionManager {
    public static let shared = PlaygroundLiveViewSessionManager()

    private init() {}

    public func sendError(hint: String, solution: String) {
        let messageValue = PlaygroundValue.dictionary([
            Constants.errorKey: PlaygroundValue.boolean(true),
            Constants.hintKey: PlaygroundValue.string(hint),
            Constants.solutionKey: PlaygroundValue.string(solution),
        ])
        send(message: messageValue)
    }

    public func sendPassMessage(message: String) {
        let messageValue = PlaygroundValue.dictionary([
            Constants.errorKey: PlaygroundValue.boolean(false),
            Constants.passKey: PlaygroundValue.string(message),
        ])
        send(message: messageValue)
    }

    private func send(message: PlaygroundValue) {
        PlaygroundPage.current.messageHandler?.send(message)
    }
}
