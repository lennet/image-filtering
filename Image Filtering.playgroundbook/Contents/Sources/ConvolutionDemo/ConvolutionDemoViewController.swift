import UIKit

struct ConvolutionOperation {
    var imageValue: RGBValue
    var kernelValue: Float
}

public class ConvolutionDemoViewController: UIViewController, UIGestureRecognizerDelegate {
    enum ConvolutionDemoState {
        case setup
        case convolving(index: Int)
        case finished
    }

    var currentState: ConvolutionDemoState = .setup {
        didSet {
            switch currentState {
            case .setup:
                animationQueue.isRunning = true
            case .convolving(index: _):
                //                animationQueue.isRunning = false
                break
            case .finished:
                animationQueue.isRunning = true
            }
        }
    }

    struct ConvolutionStep {
        var calculationSteps: [CalculationStep]
        var result: RGBValue
    }

    let kAnimationDuration = 0.75

    var imageView: ImageView?
    var kernelView: UIView?
    var originalKernelView: KernelView?
    var flippedKernelView: KernelView?
    var resultImageView: ImageView?
    var calculationView: CalculationView?

    var animationQueue = AnimationQueue()
    var showDetailedCalulation = false

    var kernel: [Float] = []
    var convolutionSteps: [ConvolutionStep] = []
    var oldSize: CGSize = .zero

    var currentIndex: Int {
        guard case let .convolving(index: i) = currentState else {
            return 0
        }
        return i
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.backgroundColor = .clear
        addGestureRecognizer()
    }

    public func reset() {
        UIView.setAnimationsEnabled(false)
        currentState = .setup
        kernel = []
        showDetailedCalulation = false
        convolutionSteps = []

        imageView?.removeFromSuperview()
        kernelView?.removeFromSuperview()
        originalKernelView?.removeFromSuperview()
        flippedKernelView?.removeFromSuperview()
        resultImageView?.removeFromSuperview()
        calculationView?.removeFromSuperview()

        imageView = nil
        kernelView = nil
        originalKernelView = nil
        flippedKernelView = nil
        resultImageView = nil
        calculationView = nil
        animationQueue.clear()
        animationQueue = AnimationQueue()
        oldSize = .zero
        UIView.setAnimationsEnabled(true)
    }

    public func displayImage(hexValues: [Int]) {
        let image = hexValues.map { UIColor(hexValue: $0) }
        displayImage(image: image)
    }

    public func displayImage(image: [UIColor]) {
        if imageView != nil {
            imageView?.removeFromSuperview()
        }

        let newImageView = ImageView(image: image)
        newImageView.alpha = 0
        view.addSubview(newImageView)

        imageView = newImageView
        layoutStartImage()

        animationQueue.addAnimation(duration: kAnimationDuration) {
            self.imageView?.alpha = 1
        }
    }

    // MARK: - Layout

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateLayout()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLayout()
    }

    func updateLayout() {
        guard view.size != oldSize else {
            return
        }
        switch currentState {
        case .setup:
            if (resultImageView?.alpha ?? 0) > 0 {
                layoutImageViewForConvolution()
            } else {
                layoutStartImage()
            }
            layoutResultImageView()
            layoutKernelStart()
        case let .convolving(index: index):
            overlapKernelLayoutChanges()
            layoutResultImageView()
            moveKernelToIndex(index: index)

            if !(calculationView?.isHidden ?? true) {
                layoutForCalculationView()
            }

        case .finished:
            layoutResultImageView()
        }

        oldSize = view.size
    }

    var defaultObjectSize: CGFloat {
        if view.size.width < view.size.height {
            return view.frame.size.width / 2
        } else {
            return (view.frame.size.height / 2) * 0.8
        }
    }

    var smallObjectSize: CGFloat {
        if view.size.width < view.size.height {
            return view.frame.size.width / 5
        } else {
            return view.frame.size.height / 5
        }
    }

    var imageViewStartRect: CGRect {
        let size = defaultObjectSize
        return CGRect(x: view.center.x - size / 2, y: view.center.y - size / 2, width: size, height: size)
    }

    var imageViewBeforeConvolutionRect: CGRect {
        let size = defaultObjectSize
        let halfSize = size / 2
        return CGRect(x: view.center.x - halfSize - size / 5, y: view.center.y - halfSize, width: size, height: size)
    }

    var kernelStartRect: CGRect {
        let size = smallObjectSize
        return CGRect(x: view.center.x + size, y: view.center.y - size / 2, width: size, height: size)
    }

    var resultConvolutionRect: CGRect {
        var rect = imageViewConvolutionRect
        rect.origin.y += rect.size.height + 20
        return rect
    }

    var imageViewConvolutionRect: CGRect {
        var rect = imageViewStartRect
        rect.origin.y -= rect.size.height / 2
        return rect
    }

    var resultImageRect: CGRect {
        let size: CGFloat
        if view.size.width < view.size.height {
            size = view.frame.size.width / 2
        } else {
            size = view.frame.size.height / 2
        }

        return CGRect(x: view.center.x - size / 2, y: view.center.y - size / 2, width: size, height: size)
    }

    var calculationViewRect: CGRect {
        let factor: CGFloat
        if view.size.width > view.size.height {
            factor = 1.75
        } else {
            factor = 2
        }
        let size = CGSize(width: view.size.width / factor, height: view.size.height)
        return CGRect(origin: CGPoint(x: view.size.width - size.width, y: view.size.height / 2 - size.height / 2), size: size)
    }

    var imageViewShowingCalculationViewRect: CGRect {
        let padding: CGFloat = 10
        let length: CGFloat
        let xOrigin: CGFloat
        if view.size.height > view.size.width {
            length = view.size.width - calculationViewRect.size.width - padding - (imageView?.pixelSize ?? 0)
            xOrigin = padding / 2 + (imageView?.pixelSize ?? 0)
        } else {
            length = (view.frame.size.height / 2) * 0.8
            xOrigin = calculationViewRect.origin.x - padding / 2 - length
        }
        let size = CGSize(width: length, height: length)

        let halfPixelSize = (imageView?.pixelSize ?? 0) / 2
        let point = CGPoint(x: xOrigin, y: (view.size.height / 2) - size.height - padding / 2 - halfPixelSize)
        return CGRect(origin: point, size: size)
    }

    var resultViewShowingCalculationViewRect: CGRect {
        var rect = imageViewShowingCalculationViewRect
        let padding: CGFloat = 10
        let halfPixelSize = (imageView?.pixelSize ?? 0) / 2
        rect.origin.y = (view.size.height / 2) + padding / 2 + halfPixelSize
        return rect
    }

    func addGestureRecognizer() {
        let panGestureRecognizer = AllTouchesPanGestureRecognizer()
        panGestureRecognizer.callBack = handlePan
        view.addGestureRecognizer(panGestureRecognizer)
    }

    func displayKernel(kernel: [Float]) {
        if self.kernelView != nil {
            self.kernelView?.removeFromSuperview()
        }

        let kernelContainer = UIView(frame: kernelStartRect)
        kernelContainer.alpha = 0

        let flippedKernel = KernelView(kernel: kernel.reversed())
        flippedKernel.l_frame = kernelStartRect
        flippedKernel.origin = .zero
        flippedKernel.showPixelBorder = true
        flippedKernel.alpha = 1

        let kernelView = KernelView(kernel: kernel)
        kernelView.l_frame = kernelStartRect
        kernelView.origin = .zero
        kernelView.showPixelBorder = true
        kernelView.alpha = 1
        kernelContainer.addSubview(kernelView)

        view.addSubview(kernelContainer)

        flippedKernelView = flippedKernel
        originalKernelView = kernelView
        self.kernelView = kernelContainer

        layoutKernelStart()

        animationQueue.addAnimation(duration: kAnimationDuration) {
            self.kernelView?.alpha = 1
        }
    }

    func layoutKernelStart() {
        kernelView?.frame = kernelStartRect
    }

    private func displayResultImageView() {
        guard let imageView = imageView else { return }

        if resultImageView != nil {
            resultImageView?.removeFromSuperview()
        }

        let whiteImage = [UIColor](repeating: .white, count: imageView.image.count)
        let newResultImageView = ImageView(image: whiteImage)
        newResultImageView.showPixelBorder = true
        newResultImageView.alpha = 0
        view.addSubview(newResultImageView)
        resultImageView = newResultImageView

        layoutResultImageView()
        resultImageView?.setNeedsDisplay()
        resultImageView?.showPixelBorder = true

        let animation = Animation(duration: kAnimationDuration, animation: {
            self.resultImageView?.alpha = 1
            self.flippedKernelView?.alpha = 1
            self.resultImageView?.setNeedsDisplay()
        }) { _ in
            self.currentState = .convolving(index: 0)
            self.setupAnimationQueueForConvolution()
        }
        animationQueue.add(animation: animation)
    }

    func layoutResultImageView() {
        if case .finished = currentState {
            resultImageView?.l_frame = resultImageRect
        } else {
            resultImageView?.l_frame = resultConvolutionRect
        }
    }

    func layoutStartImage() {
        imageView?.l_frame = imageViewStartRect
    }

    public func convolve(with kernel: [Float]) {
        guard let _ = self.imageView else {
            return
        }
        self.kernel = kernel
        configureCalculationView()
        moveImageViewBeforeConvolution()
        displayKernel(kernel: kernel)
        flipKernel()
        overlapKernel()
        displayResultImageView()
    }

    func setupAnimationQueueForConvolution() {
        animationQueue.clear()
        animationQueue = AnimationQueue()
        convolve()
        hideKernelAndGrid()
    }

    func configureCalculationView() {
        let calculationView = CalculationView(steps: [], result: RGBValue(red: 0, green: 0, blue: 9), frame: calculationViewRect)
        calculationView.isHidden = true
        calculationView.backgroundColor = .clear
        view.addSubview(calculationView)
        self.calculationView = calculationView
    }

    func moveImageViewBeforeConvolution() {
        animationQueue.addAnimation(duration: kAnimationDuration) {
            self.layoutImageViewForConvolution()
        }
    }

    func layoutImageViewForConvolution() {
        imageView?.l_frame = imageViewBeforeConvolutionRect
    }

    func flipKernel() {
        guard let originalKernelView = originalKernelView,
            let flippedKernelView = flippedKernelView else { return }
        let transition = Transition(fromView: originalKernelView, toView: flippedKernelView, duration: 0.5, mode: [.transitionFlipFromLeft, .transitionFlipFromTop], forceDuration: true)
        animationQueue.add(animation: transition)
    }

    func overlapKernel() {
        animationQueue.addAnimation(duration: kAnimationDuration) {
            self.overlapKernelLayoutChanges()
        }
    }

    func overlapKernelLayoutChanges() {
        guard let imageView = imageView,
            let flippedKernelView = flippedKernelView else { return }
        imageView.l_frame = imageViewConvolutionRect

        kernelView?.origin = CGPoint(x: imageView.origin.x - imageView.pixelSize, y: imageView.origin.y - imageView.pixelSize)
        flippedKernelView.pixelSize = imageView.pixelSize
        kernelView?.size = flippedKernelView.size
    }

    func convolve() {
        guard let imageView = self.imageView else { return }
        let pixelCount = imageView.image.count

        convolutionSteps = (0 ..< pixelCount).map { self.spatialConvolution(for: imageView.image, at: $0, with: self.kernel) }

        var currentIndex: Int
        if case let .convolving(index) = currentState {
            currentIndex = index
        } else {
            currentIndex = 0
        }

        for i in Array(currentIndex ..< pixelCount) {
            let animation = Animation(duration: kAnimationDuration, animation: {
                self.moveKernelToIndex(index: i)
                self.updateCalculationView(index: i)
            }, completion: { _ in
                self.updateResultImage(index: i)
            })

            animationQueue.add(animation: animation)
        }
    }

    func hideKernelAndGrid() {
        animationQueue.addAnimation(duration: kAnimationDuration) {
            self.currentState = .finished
            self.kernelView?.alpha = 0
            self.imageView?.alpha = 0
            self.layoutResultImageView()
        }

        let animation = Animation(duration: kAnimationDuration, animation: {
            self.resultImageView?.showPixelBorder = false
        }, completion: { _ in
            self.showSuccessMessage()
            self.currentState = .finished
        })

        animationQueue.add(animation: animation)
    }

    func moveKernelToIndex(index: Int) {
        guard let imageView = imageView else { return }
        let currentPoint = index.asPoint(totalWidth: Int(imageView.contentWidth))
        let pixelSize = imageView.pixelSize
        kernelView?.center = CGPoint(x: imageView.origin.x + (currentPoint.x * pixelSize) + pixelSize / 2, y: imageView.origin.y + (currentPoint.y * pixelSize) + pixelSize / 2)
    }

    func updateResultImage(index: Int) {
        guard !convolutionSteps.isEmpty else { return }
        resultImageView?.image = tmpResultImage(index: index, steps: convolutionSteps)
        currentState = .convolving(index: index)
        resultImageView?.setNeedsDisplay()
    }

    func updateCalculationView(index: Int) {
        let convolutionStep = convolutionSteps[index]
        calculationView?.steps = convolutionStep.calculationSteps
        calculationView?.result = convolutionStep.result
        if !(calculationView?.isHidden ?? false) {
            calculationView?.setNeedsDisplay()
        }
    }

    func moveContentForResultView() {
        calculationView?.alpha = 0
        calculationView?.isHidden = false
        calculationView?.frame = calculationViewRect
        calculationView?.setNeedsDisplay()

        UIView.animate(withDuration: 0.25, animations: {
            self.calculationView?.alpha = 1
            self.layoutForCalculationView()
        }) { _ in
            self.showDetailedCalulation = true
        }
    }

    func layoutForCalculationView() {
        guard let imageView = imageView else { return }
        guard let flippedKernelView = flippedKernelView else { return }

        resultImageView?.l_frame = resultViewShowingCalculationViewRect
        resultImageView?.setNeedsDisplay()

        imageView.l_frame = imageViewShowingCalculationViewRect
        imageView.setNeedsDisplay()

        flippedKernelView.pixelSize = imageView.pixelSize
        flippedKernelView.setNeedsDisplay()
        kernelView?.bounds = flippedKernelView.bounds
        moveKernelToIndex(index: currentIndex + 1)

        calculationView?.frame = calculationViewRect
        calculationView?.setNeedsDisplay()
    }

    func moveContentFromResultView() {
        guard let imageView = self.imageView else { return }
        guard let flippedKernelView = self.flippedKernelView else { return }

        UIView.animate(withDuration: 0.25, animations: {
            self.calculationView?.alpha = 0

            self.resultImageView?.l_frame = self.resultConvolutionRect
            self.imageView?.l_frame = self.imageViewConvolutionRect

            self.flippedKernelView?.pixelSize = imageView.pixelSize
            self.flippedKernelView?.setNeedsDisplay()
            self.kernelView?.bounds = flippedKernelView.bounds
            self.moveKernelToIndex(index: self.currentIndex)
        }) { _ in
            self.calculationView?.isHidden = true
        }
        showDetailedCalulation = false
    }

    func tmpResultImage(index: Int, steps: [ConvolutionStep]) -> [UIColor] {
        return (0 ..< steps.count).map {
            if $0 > index {
                return .white
            }
            return UIColor(value: steps[$0].result)
        }
    }

    func spatialConvolution(for image: [UIColor], at index: Int, with kernel: [Float]) -> ConvolutionStep {
        let operations = convolutionOperations(for: image, at: index, with: kernel)

        // the two-step calculation is needed for the CalculationView

        let resultValues: [RGBValue] = operations.map {
            let imageValue = $0.imageValue
            let kernelValue = $0.kernelValue

            return RGBValue(red: imageValue.red * kernelValue, green: imageValue.green * kernelValue, blue: imageValue.blue * kernelValue)
        }

        let result = resultValues.reduce(RGBValue(red: 0, green: 0, blue: 0)) { (result, resultValue) -> RGBValue in
            RGBValue(red: result.red + resultValue.red, green: result.green + resultValue.green, blue: result.blue + resultValue.blue)
        }

        let steps: [CalculationStep] = operations.enumerated().map {
            let imageValue = $1.imageValue
            let kernelValue = $1.kernelValue
            let resultValue = resultValues[$0]

            return CalculationStep(imageValue: imageValue, kernel: kernelValue, result: resultValue)
        }

        return ConvolutionStep(calculationSteps: steps, result: result)
    }

    func convolutionOperations(for image: [UIColor], at index: Int, with kernel: [Float]) -> [ConvolutionOperation] {
        // todo remove dependecies from ui
        guard let imageView = self.imageView else { return [] }
        guard let flippedKernelView = self.flippedKernelView else { return [] }

        let imageWidth = Int(imageView.contentWidth)
        let kernelWidth = Int(flippedKernelView.contentWidth)
        let currentPoint = index.asPoint(totalWidth: Int(imageWidth))

        return Array(0 ..< kernel.count).compactMap {
            let currentKernelPoint = $0.asPoint(totalWidth: kernelWidth)

            let xPos = CGFloat(currentPoint.x + currentKernelPoint.x) - CGFloat(kernelWidth / 2)
            let yPos = CGFloat(currentPoint.y + currentKernelPoint.y) - CGFloat(kernelWidth / 2)

            guard xPos >= 0, xPos < CGFloat(imageWidth), yPos >= 0, yPos < CGFloat(imageWidth) else {
                return nil
            }

            let flippedKernelPoint = CGPoint(x: CGFloat(kernelWidth) - CGFloat(1.0) - currentKernelPoint.x, y: CGFloat(kernelWidth) - CGFloat(1.0) - currentKernelPoint.y)

            let kernelValue = kernel[flippedKernelPoint.asIndex(totalWidth: kernelWidth)]
            let imageValues = image[CGPoint(x: xPos, y: yPos).asIndex(totalWidth: imageWidth)].components

            let imageValue = RGBValue(red: imageValues.red, green: imageValues.green, blue: imageValues.blue)

            return ConvolutionOperation(imageValue: imageValue, kernelValue: kernelValue)
        }
    }

    // mark - UIGestureRecognizer

    func handlePan(sender: UIPanGestureRecognizer, state: UIGestureRecognizer.State) {
        // a custom state parameter is needed to get all state changes

        guard case let .convolving(index: currentIndex) = currentState else {
            return
        }

        switch state {
        case .began:
            animationQueue.isRunning = false
            moveContentForResultView()
        case .changed:
            guard showDetailedCalulation else { return }
            let translation = sender.translation(in: view)
            let panDirection = PanDirection(translation: translation)
            guard panDirection != .none else {
                return
            }
            let contentWidth = Int(imageView?.contentWidth ?? 1)
            var currentPoint = currentIndex.asPoint(totalWidth: contentWidth)

            switch panDirection {
            case .left:
                currentPoint.x -= 1
            case .topLeft:
                currentPoint.x -= 1
                currentPoint.y += 1
            case .top:
                currentPoint.y += 1
            case .topRight:
                currentPoint.x += 1
                currentPoint.y += 1
            case .right:
                currentPoint.x += 1
            case .bottomRight:
                currentPoint.x += 1
                currentPoint.y -= 1
            case .bottom:
                currentPoint.y -= 1
            case .bottomLeft:
                currentPoint.x -= 1
                currentPoint.y -= 1
            case .none:
                break
            }
            sender.setTranslation(.zero, in: view)

            currentPoint.x = min(max(0, currentPoint.x), CGFloat(contentWidth - 1))
            currentPoint.y = min(max(0, currentPoint.y), CGFloat(contentWidth - 1))
            let newIndex = currentPoint.asIndex(totalWidth: contentWidth)

            updateResultImage(index: newIndex)
            moveKernelToIndex(index: newIndex)
            updateCalculationView(index: newIndex)

            currentState = .convolving(index: newIndex)
        case .ended:
            moveContentFromResultView()
            setupAnimationQueueForConvolution()
            animationQueue.isRunning = true
        default:
            break
        }
    }
}
