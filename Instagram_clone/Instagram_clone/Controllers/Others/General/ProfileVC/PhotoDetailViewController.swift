
import UIKit

class PhotoDetailViewController: UIViewController {

    var image: UIImage?
    
    private let closeButton: UIButton = {
       let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.tintColor = .systemGray
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return button
    }()
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .blue
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(closeButton)
        view.addSubview(imageView)
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        configureImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds
        closeButton.center = CGPoint(x: 30, y: 50)
        view.bringSubviewToFront(closeButton)
    }

    @objc func didTapCloseButton() {
        self.dismiss(animated: true)
    }
    
    private func configureImage() {
        guard let hasImage = image else {
            return
        }
        imageView.image = hasImage
    }
}
