
import UIKit

class TagPeopleViewController: UIViewController {
    
    var image: UIImage?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let defaultLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap photo to tag people."
        label.textColor = .lightGray
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureNaviBar()
        addSubViews()
        addGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        assignFrames()
    }
    
    private func configureNaviBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDoneButton))
    }
    
    @objc func didTapDoneButton() {
        print(1)
        self.dismiss(animated: true)
    }
    
    private func addSubViews() {
        self.view.addSubview(imageView)
        imageView.image = self.image
        
        self.view.addSubview(defaultLabel)
    }
    
    private func assignFrames() {
        let statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let naviBarHeight = self.navigationController?.navigationBar.height ?? 0
        let viewHeight = self.view.height - (statusHeight + naviBarHeight)
        imageView.frame = CGRect(x: 0, y: statusHeight + naviBarHeight, width: self.view.width, height: viewHeight / 2)
        defaultLabel.frame = CGRect(x: 90, y: imageView.bottom + 100, width: self.view.width - 180, height: 50)
    }

    private func addGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(gesture)
    }
    
    @objc func didTapImageView() {
        let exploreVC = ExploreViewController()
        exploreVC.view.backgroundColor = .systemBackground
        exploreVC.modalPresentationStyle = .fullScreen
        self.present(exploreVC, animated: true)
    }
}
