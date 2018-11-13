import UIKit.UIGestureRecognizerSubclass

public class AllTouchesPanGestureRecognizer: UIPanGestureRecognizer {
    public var callBack: ((_ recognizer: AllTouchesPanGestureRecognizer, _ state: UIGestureRecognizer.State) -> Void)?

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        state = .began
        callBack?(self, .began)
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        callBack?(self, .changed)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        callBack?(self, .ended)
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        callBack?(self, .cancelled)
    }
}
