
import UIKit

final class ProfileViewController: UIViewController {
    enum Result: String {
        case success = "1"
        case failure = "0"
    }
    
    var index = 0 // 0: oneself, 1: the other
    
    var user: User? = nil // when index is 1, the other's userInfo
    
    private let naviBarLabel = UILabel()
    
    private var collectionView: UICollectionView?
    
    var dataType = 0 // 0: normal post, 1: mentioned post
    
    private lazy var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(naviBarLabel)
        configureNavigationBar()
        configureCollectionView()
        configurePosts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationItem.titleView = naviBarLabel
        collectionView?.frame = view.bounds
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureNavigationBar()
        reloadHeaderView()
        (self.view.viewWithTag(4) as! ProfileInfoHeaderCollectionReusableView).configurePostsButtonTitle()
        (self.view.viewWithTag(4) as! ProfileInfoHeaderCollectionReusableView).configureFollowingButtonTitle()
        (self.view.viewWithTag(4) as! ProfileInfoHeaderCollectionReusableView).configureFollowersButtonTitle()
        configurePosts()
    }
    
    private func reloadHeaderView() {
        let profileHeaderCollectView = view.viewWithTag(4) as! ProfileInfoHeaderCollectionReusableView
        if index == 0 {
            profileHeaderCollectView.configureName()
            profileHeaderCollectView.configureBio()
            profileHeaderCollectView.layoutSubviews()
        } else {
            let theOtherProfileHeaderCollectionView = profileHeaderCollectView as! TheOtherProfileInfoHeaderCollectionReusableView
            
            DatabaseManager.shared.readUser(username: nil, email: self.user!.email) { user in
                DispatchQueue.main.async {
                    self.user = user
                    theOtherProfileHeaderCollectionView.user = self.user!
                    theOtherProfileHeaderCollectionView.configureProfileImage()
                    theOtherProfileHeaderCollectionView.reConfigureBio()
                    theOtherProfileHeaderCollectionView.isFrameSet = false
                    theOtherProfileHeaderCollectionView.layoutSubviews()
                }
            }
        }
    }
    
    private func configureNavigationBar() {
        if index == 0 {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettingButton))
            self.navigationItem.rightBarButtonItem?.tintColor = .systemGray
            
            configureNaviBarLabel()
            self.navigationItem.backButtonTitle = ""
        } else {
            configureNaviBarLabel()
            
        }
    }
    
    private func configureNaviBarLabel() {
        naviBarLabel.frame = CGRect(x: 0, y: 0, width: 250, height: 100)
        naviBarLabel.textAlignment = .center
        
        if index == 0 {
            naviBarLabel.font = .systemFont(ofSize: 30, weight: .bold)
            naviBarLabel.text = StorageManager.shared.callUserInfo()?.username
        } else {
            naviBarLabel.font = .systemFont(ofSize: 25, weight: .bold)
            DatabaseManager.shared.readUser(username: nil, email: self.user!.email) { user in
                DispatchQueue.main.async {
                    self.user = user
                    self.naviBarLabel.text = self.user!.username
                }
            }
        }
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        let size = (view.width - 4) / 3
        layout.itemSize = CGSize(width: size, height: size)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView?.register(ProfileInfoHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier)
        collectionView?.register(TheOtherProfileInfoHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TheOtherProfileInfoHeaderCollectionReusableView.identifier2)
        
        collectionView?.register(ProfileTabsCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileTabsCollectionReusableView.identifier)
        
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        guard let hasCollectionView = collectionView else {
            return
        }
        
        view.addSubview(hasCollectionView)
    }
    
    
    private func configurePosts() {
        var userId = 0
        
        if index == 0 {
            userId = StorageManager.shared.callUserInfo()!.id
        } else {
            if let hasUser = user {
                userId = hasUser.id
            }
        }
        
        if dataType == 0 {
            DatabaseManager.shared.readAllPostsByUserIdList([userId]) { posts in
                DispatchQueue.main.async {
                    self.posts = posts
                    self.collectionView?.reloadData()
                }
            }
        } else {
            DatabaseManager.shared.readTaggedPostsByUserId(userId) { posts in
                DispatchQueue.main.async {
                    self.posts = posts
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    
    
    @objc func didTapSettingButton() {
        let settingVC = SettingViewController()
        settingVC.title = "Settings"
        navigationController?.pushViewController(settingVC, animated: true)
        self.navigationController?.navigationBar.tintColor = .black
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
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        
        var username = ""
        let postId = self.posts[indexPath.row].id
        let postUsername = self.posts[indexPath.row].username
        
        if index == 0 {
            if dataType == 0 {
                username = StorageManager.shared.callUserInfo()!.username
            } else {
                username = postUsername
            }
        } else {
            if dataType == 0 {
                if let hasUser = user {
                    username = hasUser.username
                }
            } else {
                username = postUsername
            }
        }
        cell.imageView.setPostImage(username: username, postId: postId)
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
        var profileHeader = ProfileInfoHeaderCollectionReusableView()
        if self.index == 0 {
            profileHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier, for: indexPath) as! ProfileInfoHeaderCollectionReusableView
        } else {
            let theOtherProfileHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TheOtherProfileInfoHeaderCollectionReusableView.identifier2, for: indexPath) as! TheOtherProfileInfoHeaderCollectionReusableView
            theOtherProfileHeader.user = user
            theOtherProfileHeader.selfDelegate = self
            profileHeader = theOtherProfileHeader
        }
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
        var height: CGFloat = 0
        if index == 0 {
            height = profileHeader.bioLabel.frame.origin.y + profileHeader.bioLabel.frame.size.height + 30 + profileHeader.editProfileButton.height + 10
        } else {
            height = profileHeader.bioLabel.frame.origin.y + profileHeader.bioLabel.frame.size.height + 10
        }
        profileHeader.frame.size = CGSize(width: collectionView.width, height: height)
        return CGSize(width: collectionView.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let postListVC = PostListViewController()
        postListVC.posts = self.posts
        postListVC.titleText = "Post"
        postListVC.indexpathRow = indexPath.row
        self.navigationController?.pushViewController(postListVC, animated: true)
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    
}

extension ProfileViewController: ProfileInfoHeaderCollectionReusableViewDelegate {
    func profileHeaderDidTapProfileImageView(_ image: UIImage) {
        guard image != UIImage(named: "profileImage2") else {
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
        self.tabBarController?.view.addSubview(addProfileMenuView)
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
        let followVC = FollowViewController()
        followVC.index = 0
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        self.navigationController?.pushViewController(followVC, animated: true)
    }

    func profileHeaderDidTapFollowingButton() {
        let followVC = FollowViewController()
        followVC.index = 1
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        self.navigationController?.pushViewController(followVC, animated: true)
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
    func configurePostCells() {
        self.dataType = 0
        self.configurePosts()
    }
    
    func configureTagCells() {
        self.dataType = 1
        self.configurePosts()
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
        self.tabBarController?.view.viewWithTag(7)?.removeFromSuperview()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func presentLibrary(_ vc: UIViewController) {
        present(vc, animated: true)
    }
    
    func addProfileImage(_ image: UIImage) {
        let user = StorageManager.shared.callUserInfo()!
        let filename = user.email
        
        StorageManager.shared.saveAtDirectory(image: image, imageName: filename)
        StorageManager.shared.uploadImage(paramName: "file", fileName: filename, image: image)
        DatabaseManager.shared.updateUser(user: user) { _ in }
        
        viewDidAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
  
    
}

extension ProfileViewController: TheOtherProfileInfoHeaderCollectionReusableViewDelegate {
    func didTapFollowButton(myUserId: Int, followingToUserId: Int) {
        DatabaseManager.shared.insertFollowing(myUserId: myUserId, followToUserId: followingToUserId) { result in
            if result == Result.success.rawValue {
                DispatchQueue.main.async {
                    (self.view.viewWithTag(4) as! TheOtherProfileInfoHeaderCollectionReusableView).configureMessageButton()
                    (self.view.viewWithTag(4) as! ProfileInfoHeaderCollectionReusableView).configureFollowersButtonTitle()
                }
            }
        }
    }
    
    
}
