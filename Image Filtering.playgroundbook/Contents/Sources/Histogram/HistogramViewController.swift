import CoreMotion
import SceneKit
import UIKit

public class HistogramViewController: UIViewController, SCNSceneRendererDelegate {
    let motionManager = CMMotionManager()

    weak var histogramView: HistogramView?
    var deviceQuaternion: CMQuaternion?

    public init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        configureSceneView(image: image)
//        configureMotionManager()
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureSceneView(image: UIImage) {
        let histogramView = HistogramView(frame: view.bounds, image: image)
        histogramView.backgroundColor = .clear
//        histogramView.delegate = self
//        histogramView.isPlaying = true
        histogramView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(histogramView)
        self.histogramView = histogramView
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func configureMotionManager() {
        // doesn't work in swift playground for iPad because we don't have the device's orientation
        motionManager.deviceMotionUpdateInterval = 1 / 30
        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: OperationQueue()) { motion, _ in
            self.deviceQuaternion = motion?.attitude.quaternion
        }
    }

    // mark - SCNSceneRendererDelegate

//    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    //
//        guard let quaternion = self.deviceQuaternion else {
//            return
//        }
    //
//        guard let histogramView = self.histogramView else { return }
    //
    //
    ////        let threshold = 0.25
    ////        let scnQuaternion = SCNQuaternion(max(min(quaternion.x, threshold),-threshold), max(min(quaternion.y, threshold),-threshold), max(min(quaternion.z, threshold),-threshold), max(min(quaternion.w, threshold),-threshold))
    ////
    ////        //        print(scnQuaternion)
    ////        histogramView.redNode.orientation = scnQuaternion
    ////
    ////        histogramView.greenNode.orientation = scnQuaternion
    ////        histogramView.blueNode.orientation = scnQuaternion
    ////
    //
//    }
}
