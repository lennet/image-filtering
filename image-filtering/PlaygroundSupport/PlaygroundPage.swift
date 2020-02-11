//
//  PlaygroundPage.swift
//  PlaygroundSupport
//
//  Created by Leo Thomas on 13.11.17.
//  Copyright © 2017 Leonard Thomas. All rights reserved.
//

import Foundation
import UIKit

public protocol LiveViewable {}

extension UIView: LiveViewable {}
extension UIViewController: LiveViewable {}

public enum AssesmentStatus {
    case fail(hints: [String], solution: String?)
    case pass(message: String)
}

public class PlaygroundPage {
    public static var current = PlaygroundPage()
    public var assessmentStatus: AssesmentStatus?
    public var liveView: LiveViewable!
    public var needsIndefiniteExecution = true
    public func finishExecution() {}
}

public protocol PlaygroundRemoteLiveViewProxyDelegate {}

public class PlaygroundRemoteLiveViewProxy {
    public var delegate: Any?
}

public enum PlaygroundValue {
    case array([PlaygroundValue])
    case integer(Int)
    case string(String)
    case data(Data)
    case dictionary([String: PlaygroundValue])
    case boolean(Bool)
    case floatingPoint(Float)
}

public class PlaygroundKeyValueStore {
    public static var current = PlaygroundKeyValueStore()
    public subscript(_: String) -> PlaygroundValue? {
        get {
            return nil
        }
        set {}
    }
}

public protocol PlaygroundLiveViewMessageHandler {
    func send(_ message: PlaygroundValue)
}

extension PlaygroundLiveViewMessageHandler {
    public func send(_: PlaygroundValue) {}
}
