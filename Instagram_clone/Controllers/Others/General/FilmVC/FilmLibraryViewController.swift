
import UIKit
import Photos

class FilmLibraryViewController: CommonForm {
    
    private var originalImage: UIImage?
    
    private var cellList = [Bool]()    // cellState(isChecked) list
    
    private var oldIndexPath: IndexPath?
    
    private lazy var images = [PHAsset]()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let filterButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white.withAlphaComponent(0.5)
        button.setBackgroundImage(UIImage(systemName: "pencil.circle"), for: .normal)
        return button
    }()
    
    private var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPhotos()
        imageView.addSubview(filterButton)
        view.addSubview(imageView)
        configureCollectionView()
        imageView.bringSubviewToFront(filterButton)
        
        filterButton.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
    }
    
    @objc func didTapFilterButton() {
        self.tabBarController?.tabBar.isHidden = true
        filterButton.isHidden = true
        changeNaviBar()
        changeCollectionView()
    }
    
    @objc func didTapBackButton() {
        super.configureNaviBar()
        self.navigationItem.titleView = nil
        filterButton.isHidden = false
        self.view.subviews.last?.removeFromSuperview()
        self.imageView.image = originalImage
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func changeNaviBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(didTapBackButton))
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        
        self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(CGFloat(0.2), for: UIBarMetrics.default)
        let titleImageView = UIImageView(image: UIImage(systemName: "pencil"))
        titleImageView.tintColor = .white
        self.navigationItem.titleView = titleImageView
        let naviBarHeight = self.navigationController?.navigationBar.height ?? 0
        titleImageView.frame.size = CGSize(width: naviBarHeight/2, height: naviBarHeight/2)
        
        let transition = CATransition.init()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.default)
        transition.type = CATransitionType.push // Transition you want like Push, Reveal
        transition.subtype = CATransitionSubtype.fromRight // Direction like Left to Right, Right to Left
        self.navigationItem.titleView?.layer.add(transition, forKey: kCATransition)
    }
    
    private func changeCollectionView() {
        let statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let naviBarHeight = self.navigationController?.navigationBar.height ?? 0
        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0
        let totalViewHeight = view.height - statusHeight - naviBarHeight - tabBarHeight
        let frame = CGRect(x: 0, y: imageView.bottom, width: view.width, height: totalViewHeight * 0.4)
        
        let filterView = ImageFilterView(frame: frame)
        filterView.image = self.imageView.image
        filterView.backgroundColor = .black
        filterView.delegate = self
        self.view.addSubview(filterView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        assignFrames()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard originalImage == nil else {
            return
        }
        defaultSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.view.subviews.last is ImageFilterView {
            return
        }
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func assignFrames() {
        let statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let naviBarHeight = self.navigationController?.navigationBar.height ?? 0
        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0
        let totalViewHeight = view.height - statusHeight - naviBarHeight - tabBarHeight
        imageView.frame = CGRect(x: 0, y: statusHeight + naviBarHeight, width: view.width, height: totalViewHeight * 0.6)
        collectionView?.frame = CGRect(x: 0, y: imageView.bottom, width: view.width, height: totalViewHeight * 0.4)
        filterButton.frame = CGRect(x: view.width - 50, y: imageView.bottom - 120, width: 40, height: 40)
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let size = (self.view.width - 3) / 4
        layout.itemSize = CGSize(width: size, height: size)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        guard let hasCollectionView = collectionView else {
            return
        }
        self.view.addSubview(hasCollectionView)
    }
    
    private func setPhotos() {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { [weak self] status in
            if status == .authorized {
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                assets.enumerateObjects { (object, _, _) in
                    self?.images.append(object)
                }
                self?.images.reverse()
                
                for _ in 0..<self!.images.count {
                    self?.cellList.append(false)
                }
                
                guard let hasCollectionView = self?.collectionView else {
                    return
                }
                DispatchQueue.main.async {
                    hasCollectionView.reloadData()
                }
            }
        }
    }
    
    private func setImageOnImageView(_ indexPathRow: Int) {
        let asset = images[indexPathRow]
        let manager = PHImageManager.default()
        
        manager.requestImage(for: asset, targetSize: CGSize(width: imageView.width, height: imageView.height), contentMode: .aspectFill, options: nil) { image, _ in
            DispatchQueue.main.async {
                self.imageView.image = image
                self.originalImage = image
            }
        }
    }
    
    private func defaultSetting() {
        let indexPath = IndexPath(row: 0, section: 0)
        
        guard let hasCollectionView = collectionView else {
            return
        }
        self.collectionView(hasCollectionView, didSelectItemAt: indexPath)
    }
    
    override func didTapNextButton() {
        let postUploadVC = PostUploadViewController()
        postUploadVC.title = "New Post"
        postUploadVC.image = imageView.image
        self.navigationController?.pushViewController(postUploadVC, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(didTapNaviBackButton))
        self.navigationItem.backBarButtonItem?.tintColor = .systemGray
    }
    
    @objc func didTapNaviBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension FilmLibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        
        let asset = images[indexPath.row]
        let manager = PHImageManager.default()
        
        manager.requestImage(for: asset, targetSize: CGSize(width: cell.width, height: cell.height), contentMode: .aspectFit, options: nil) { image, _ in
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
        }
        
        if let value = cellList[indexPath.row] as? Bool {
            if value {
                cell.contentView.backgroundColor = .white.withAlphaComponent(0.5)
            } else {
                cell.contentView.backgroundColor = nil
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let hasOldIndexPath = oldIndexPath {
            cellList[hasOldIndexPath.row] = false
        }
        oldIndexPath = indexPath
        if oldIndexPath?.row ?? 0 >= 0 && oldIndexPath?.row ?? 0 < cellList.count {
            cellList[oldIndexPath!.row] = true
            self.setImageOnImageView(indexPath.row)
            collectionView.reloadData()
        }
    }
    
}

extension FilmLibraryViewController: ImageFilterViewDelegate {
    func changeImageOnImageView(_ image: UIImage) {
        self.imageView.image = image
    }
    
    
}
