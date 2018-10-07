import UIKit

public class CompareImagesViewController: UIViewController {
    var stackView: UIStackView!

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard stackView == nil else { return }

        view.backgroundColor = .clear

        stackView = UIStackView()
        stackView.backgroundColor = .white

        let margin: CGFloat = 80
        stackView.frame = CGRect(x: margin, y: margin, width: view.size.width - (2 * margin), height: view.size.height - (2 * margin))

        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 5

        view.addSubview(stackView)
    }

    public func addImage(image: UIImage) {
        let showImageViewController = ShowImageViewController(image: image)
        addChild(showImageViewController)
        stackView.addArrangedSubview(showImageViewController.view)
        showImageViewController.didMove(toParent: self)
    }

    public func reset() {
        children.forEach {
            stackView.removeArrangedSubview($0.view)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
    }
}
