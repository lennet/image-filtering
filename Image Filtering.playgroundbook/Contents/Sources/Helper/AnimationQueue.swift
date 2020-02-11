import UIKit

public typealias completionBlock = (Bool) -> Void
public typealias animationBlock = () -> Void

public protocol Animtable {
    func animate(completion: @escaping () -> Void)
    var animation: animationBlock { get }
}

public struct Animation: Animtable {
    
    var duration: TimeInterval
    var completion: completionBlock?

    public var animation: animationBlock

    public init(duration: TimeInterval, completion: completionBlock?, animation: @escaping animationBlock) {
        self.duration = duration
        self.completion = completion
        self.animation = animation
    }

    public func animate(completion: @escaping animationBlock) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: animation) { success in
            completion()
            self.completion?(success)
        }
    }
}

extension Animation {
    public init(duration: TimeInterval, animation: @escaping animationBlock, completion: completionBlock? = nil) {
        self.duration = duration
        self.animation = animation
        self.completion = completion
    }
}

public struct Transition: Animtable {
    public var animation: animationBlock {
        return {
            let superView = self.fromView.superview
            self.fromView.removeFromSuperview()
            superView?.addSubview(self.toView)
        }
    }

    var fromView: UIView
    var toView: UIView
    var duration: Double
    var mode: UIView.AnimationOptions
    var completion: completionBlock?

    public func animate(completion: @escaping animationBlock) {
        UIView.transition(from: fromView, to: toView, duration: duration, options: mode) { success in
            completion()
            self.completion?(success)
        }
    }

    public init(fromView: UIView, toView: UIView, duration: Double, mode: UIView.AnimationOptions, forceDuration _: Bool, completion: completionBlock? = nil) {
        self.fromView = fromView
        self.toView = toView
        self.duration = duration
        self.mode = mode
        self.completion = completion
    }
}

public class AnimationQueue {
    var isRunning: Bool = true {
        didSet {
            if isRunning, oldValue != isRunning {
                animateNext()
            }
        }
    }

    private var animations: [Animtable] = []

    public init() {}

    public func add<T: Animtable>(animation: T) {
        animations.append(animation)
        if animations.count == 1 {
            animateNext()
        }
    }

    public func addAnimation(duration: TimeInterval, animation: @escaping () -> Void) {
        let animation = Animation(duration: duration, animation: animation)
        add(animation: animation)
    }

    public func clear() {
        animations.removeAll()
    }

    private func animateNext() {
        guard isRunning else {
            return
        }

        animations.first?.animate {
            self.removeFirstAnimation()
            self.animateNext()
        }
    }

    private func removeFirstAnimation() {
        if !animations.isEmpty {
            animations.remove(at: 0)
        }
    }
}
