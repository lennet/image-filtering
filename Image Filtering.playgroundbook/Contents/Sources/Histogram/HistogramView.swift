import Accelerate
import SceneKit
import UIKit

public class HistogramView: SCNView {
    var cameraNode: SCNNode?
    var data: HistogramData!

    var redNode: SCNNode!
    var greenNode: SCNNode!
    var blueNode: SCNNode!

    public init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
        configureScene()
        configureLight()
        configureCamera()
        configureChannelNodes(image: image)
    }

    override init(frame: CGRect, options: [String: Any]? = nil) {
        super.init(frame: frame, options: options)
        // workaround for the swift compiler bug
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configureScene() {
        scene = SCNScene()
    }

    func configureLight() {
        let light = SCNLight()
        light.type = SCNLight.LightType.omni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: 5, y: 5, z: 105)

        let ambientLight = SCNLight()
        ambientLight.type = SCNLight.LightType.ambient
        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight
        ambientLightNode.position = SCNVector3(x: 5, y: 5, z: 105)

        scene?.rootNode.addChildNode(lightNode)
        scene?.rootNode.addChildNode(ambientLightNode)
    }

    func configureCamera() {
        let camera = SCNCamera()

        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 14)

        let centerBox = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        let centerNode = SCNNode(geometry: centerBox)

        let constraint = SCNLookAtConstraint(target: centerNode)
        constraint.isGimbalLockEnabled = true
        cameraNode.constraints = [constraint]

        scene?.rootNode.addChildNode(cameraNode)
        allowsCameraControl = true
        self.cameraNode = cameraNode
    }

    func configureChannelNodes(image: UIImage) {
        data = image.getHistogramValues()
        updateNodes()
    }

    func getNode(for channel: [vImagePixelCount], color: UIColor, maxValue: vImagePixelCount, zValue: Float) -> SCNNode {
        let size = CGSize(width: 10, height: 10)

        var points: [CGPoint] = channel.enumerated().map {
            index, element in

            let y = (CGFloat(element) / CGFloat(maxValue) * size.height)
            let x = CGFloat(index) / CGFloat(channel.count) * size.width

            // plus 0.01 avoids holes caused by zero values
            return CGPoint(x: x, y: y + 0.01)
        }

        points.append(CGPoint(x: size.width, y: 0))
        points.insert(CGPoint(x: 0, y: 0), at: 0)

        let path = UIBezierPath(points: points, interpolation: .linear)

        path.close()
        let shape = SCNShape(path: path, extrusionDepth: 0.3)

        let material = SCNMaterial()
        material.diffuse.contents = color.withAlphaComponent(0.8)
        shape.materials = [material]

        let node = SCNNode(geometry: shape)

        node.pivot = SCNMatrix4MakeTranslation(Float(size.width) / 2, Float(size.width) / 2, zValue)

        return node
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        cameraNode?.position.z = Float(size.height / size.width) * (size.width > size.height ? 14.0 : 12.0)
    }

    func updateNodes() {
        let maxValue = max(data.green.max() ?? 0, data.blue.max() ?? 0, data.red.max() ?? 0)

        redNode = getNode(for: data.red, color: .red, maxValue: maxValue, zValue: 3)
        greenNode = getNode(for: data.green, color: .green, maxValue: maxValue, zValue: 2)
        blueNode = getNode(for: data.blue, color: .blue, maxValue: maxValue, zValue: 1)

        scene?.rootNode.addChildNode(redNode)
        scene?.rootNode.addChildNode(greenNode)
        scene?.rootNode.addChildNode(blueNode)
    }
}
