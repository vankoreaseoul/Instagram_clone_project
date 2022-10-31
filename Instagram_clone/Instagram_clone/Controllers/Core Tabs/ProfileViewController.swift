
import UIKit

final class ProfileViewController: UIViewController {
    
    private var collectionView: UICollectionView?
    
    private lazy var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        let size = (view.width - 4) / 3
        layout.itemSize = CGSize(width: size, height: size)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView?.register(ProfileInfoHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier)
        collectionView?.register(ProfileTabsCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileTabsCollectionReusableView.identifier)
        
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        guard let hasCollectionView = collectionView else {
            return
        }
        
        view.addSubview(hasCollectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureNavigationBar()
        reloadHeaderView()
    }
    
    private func reloadHeaderView() {
        let profileHeaderCollectView = view.viewWithTag(4) as! ProfileInfoHeaderCollectionReusableView
        profileHeaderCollectView.configureName()
        profileHeaderCollectView.configureBio()
        profileHeaderCollectView.layoutSubviews()
    }
    
    private func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettingButton))
        self.navigationItem.rightBarButtonItem?.tintColor = .systemGray
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30.0, weight: .bold)]
        self.navigationController?.navigationBar.topItem?.title = StorageManager.shared.callUserInfo()?.username
        self.navigationItem.backButtonTitle = "Back"
    }
    
    @objc func didTapSettingButton() {
        let settingVC = SettingViewController()
        settingVC.title = "Settings"
        navigationController?.pushViewController(settingVC, animated: true)
    }
    

}


extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        if indexPath.section == 1 {
            let tabHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileTabsCollectionReusableView.identifier, for: indexPath) as! ProfileTabsCollectionReusableView
            tabHeader.tag = 5
            tabHeader.delegate = self
            return tabHeader
        }
        let profileHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier, for: indexPath) as! ProfileInfoHeaderCollectionReusableView
        profileHeader.tag = 4
        profileHeader.delegate = self
        return profileHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            if let tabHeader = view.viewWithTag(5) as? ProfileTabsCollectionReusableView {
                tabHeader.frame.origin.y = (view.viewWithTag(4) as! ProfileInfoHeaderCollectionReusableView).frame.height + 10
                collectionView.reloadData()
            }
            return CGSize(width: collectionView.width, height: 50)
        }
        guard let profileHeader = view.viewWithTag(4) as? ProfileInfoHeaderCollectionReusableView else {
            return CGSize(width: collectionView.width, height: collectionView.height/2.8)
        }
        let height = profileHeader.bioLabel.frame.origin.y + profileHeader.bioLabel.frame.size.height + 30 + profileHeader.editProfileButton.height + 10
        profileHeader.frame.size = CGSize(width: collectionView.width, height: height)
        return CGSize(width: collectionView.width, height: height)
    }
    
    
}

extension ProfileViewController: ProfileInfoHeaderCollectionReusableViewDelegate {
    func profileHeaderDidTapProfileImageView(_ image: UIImage) {
        guard image.size.width > 680 else {
            return showMenuSheet()
        }
        let photoDetailVC = PhotoDetailViewController()
        photoDetailVC.image = image
        photoDetailVC.modalPresentationStyle = .fullScreen
        self.navigationController?.present(photoDetailVC, animated: true)
    }
    
    private func showMenuSheet() {
        let addProfileMenuView = AddProfileImageMenuView()
        addProfileMenuView.tag = 7
        addProfileMenuView.delegate = self
        self.view.addSubview(addProfileMenuView)
        addProfileMenuView.frame = CGRect(x: 0, y: view.height, width: view.width, height: 0)
        
        UIView.animate(withDuration: 0.5,
                         delay: 0, usingSpringWithDamping: 1.0,
                         initialSpringVelocity: 1.0,
                         options: .curveEaseInOut, animations: {
            addProfileMenuView.frame = self.view.bounds
          }, completion: nil)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func resetHeaderViewHeight() {
        let cgSize1 = self.collectionView(collectionView!, layout: collectionView!.collectionViewLayout, referenceSizeForHeaderInSection: 0)
        let cgSize2 = self.collectionView(collectionView!, layout: collectionView!.collectionViewLayout, referenceSizeForHeaderInSection: 1)
    }

    func profileHeaderDidTapPostsButton() {
                
    }

    func profileHeaderDidTapFollowersButton() {
        
    }

    func profileHeaderDidTapFollowingButton() {
        
    }
    
    func profileHeaderDidTapEditProfileButton() {
        let editProfileVC = EditProfileViewController()
        editProfileVC.title = "Edit Profile"
        let editProfileNaviVC = UINavigationController(rootViewController: editProfileVC)
        editProfileNaviVC.modalPresentationStyle = .fullScreen
        present(editProfileNaviVC, animated: true)
    }
    
    
}

extension ProfileViewController: ProfileTabsCollectionReusableViewDelegate {
    func configureLikeCells() {
        for i in 0..<30 {
            let indexPath = IndexPath(row: i, section: 1)
            let cell = collectionView?.cellForItem(at: indexPath)
            cell?.backgroundColor = .black.withAlphaComponent(0.5)
        }
    }
    
    func configurePostCells() {
        for i in 0..<30 {
            let indexPath = IndexPath(row: i, section: 1)
            let cell = collectionView?.cellForItem(at: indexPath)
            cell?.backgroundColor = .systemGray.withAlphaComponent(0.5)
        }
    }
    

}

extension ProfileViewController: EditProfileImageMenuViewDelegate {
    func presentCamera(_ vc: UIViewController) {
        return
    }
    
    func removeProfileImage() {
        return
    }
    
    func closeMenuSheet() {
        view.viewWithTag(7)?.removeFromSuperview()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func presentLibrary(_ vc: UIViewController) {
        present(vc, animated: true)
    }
    
    func addProfileImage(_ image: UIImage) {
        let user = StorageManager.shared.callUserInfo()!
        let filename = user.getEmail()
        
        StorageManager.shared.saveAtDirectory(image: image, imageName: filename)
        StorageManager.shared.uploadImage(paramName: "file", fileName: filename, image: image)
        viewDidAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
  
    
    
}
