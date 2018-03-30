import UIKit

public class ShowImageViewController: UIViewController {
    var histogramViewController: HistogramViewController?
    var image: UIImage
    var imageView: UIImageView!

    public init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .clear
        configureImageView(image: image)
        configureHistogramView(image: image)
    }

    var objectSize: CGSize {
        return CGSize(width: view.size.width, height: view.size.height / 2)
    }

    func configureImageView(image: UIImage) {
        imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit

        view.addSubview(imageView)
    }

    func configureHistogramView(image: UIImage) {
        let histogramViewController = HistogramViewController(image: image)
        l_add(childViewController: histogramViewController)

        self.histogramViewController = histogramViewController
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        imageView.frame = CGRect(origin: .zero, size: objectSize)
        histogramViewController?.view.frame = CGRect(origin: CGPoint(x: 0, y: objectSize.height), size: objectSize)
    }
}
