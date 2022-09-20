
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
            let tabHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileTabsCollectionReusableView.identifier, for: indexPath)
            return tabHeader
        }
        let profileHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier, for: indexPath) as! ProfileInfoHeaderCollectionReusableView
        profileHeader.tag = 4
        profileHeader.delegate = self
        return profileHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: collectionView.width, height: 50)
        }
        return CGSize(width: collectionView.width, height: collectionView.height/3)
    }
    
    
    
}

extension ProfileViewController: ProfileInfoHeaderCollectionReusableViewDelegate {
    func profileHeaderDidTapProfileImageView() {
        
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
