
import UIKit
import Photos

class FilmViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    private func configureTabBar() {
        let tabBarAppearance = UITabBarAppearance()
        let tabBarItemAppearance = UITabBarItemAppearance()
        
        tabBarAppearance.backgroundColor = .black
        
        tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.8)]
        tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0)]
        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        
        self.tabBar.standardAppearance = tabBarAppearance
        self.tabBar.scrollEdgeAppearance = tabBarAppearance
    }
}


class CommonForm: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureNaviBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func configureNaviBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancelButton))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(didTapNextButton))
    }
    
    @objc func didTapCancelButton() {
        self.dismiss(animated: true)
    }
    
    @objc func didTapNextButton() {

    }

}

class FilmLibraryViewController: CommonForm {
    
    private lazy var images = [PHAsset]()
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        return imageView
    }()
    
    private let collectionView: UICollectionView = {
       let collectionView = UICollectionView()
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPhotos()
    }
    
    private func setPhotos() {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { [weak self] status in
            if status == .authorized {
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                assets.enumerateObjects { (object, _, _) in
                    self?.images.append(object)
                    self?.images.reverse()
                    // self.collectionView?.reloadData()
                }
            }
        }
    }
    
}

class FilmPhotoViewController: CommonForm {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class FilmVideoViewController: CommonForm {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
