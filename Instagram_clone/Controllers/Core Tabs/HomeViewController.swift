
import UIKit

class HomeViewController: UIViewController {
    
    private var followingList = [User]()
    
    var posts = [Post]()
    
    private let header: UIView = {
       let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let logoImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "textLogo")
        return imageView
    }()
    
    private var collectionView: UICollectionView? // data: followingList
    
    public var tableView: UITableView? // data: postList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate  // for pop up FilmViewController
        
        addSubViews()
        configureCollectionView()
        configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        assignFrames()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkSignin()
        setFollowingList()
        scrollToFirstRow()
    }

    
    public func scrollToFirstRow() {
        if posts.count > 0 {
            let indexPath = NSIndexPath(row: 0, section: 0)
            self.tableView?.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
        }
    }
    
    private func checkSignin() {
        let isSignedIn = UserDefaults.standard.isSignedIn()
        if isSignedIn == false {
            let signinVC = SignInViewController()
            signinVC.modalPresentationStyle = .fullScreen
            self.present(signinVC, animated: true)
        }
    }
    
    public func setFollowingList() {
        guard let hasUser = StorageManager.shared.callUserInfo() else {
            return
        }
        let myUserId = hasUser.id
        self.followingList.removeAll()
        DatabaseManager.shared.readFollowingList(myUserId: myUserId) { users in
            self.followingList.append(hasUser)
            for user in users {
                self.followingList.append(user)
            }
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
                self.loadPosts()
            }
        }
    }
    
    private func loadPosts() {
        if !followingList.isEmpty {
            var userIdList = [Int]()
            for user in followingList {
                let userId = user.id
                userIdList.append(userId)
            }
            
            DatabaseManager.shared.readAllPostsByUserIdList(userIdList) { posts in
                if !self.posts.isEmpty {
                    self.posts.removeAll()
                }
                self.posts = posts
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
            }
        }
    }
    
    private func addSubViews() {
        view.addSubview(header)
        header.addSubview(logoImageView)
    }
    
    public func assignFrames() {
        let statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0
        header.frame = CGRect(x: 0, y: statusHeight, width: view.width, height: 50)
        logoImageView.frame = CGRect(x: 10, y: 0, width: 150, height: 50)
        collectionView?.frame = CGRect(x: 0, y: header.bottom, width: view.width, height: 100)
        
        let line = UIView()
        line.backgroundColor = .systemGray.withAlphaComponent(0.3)
        view.addSubview(line)
        line.frame = CGRect(x: 0, y: collectionView!.bottom - 1, width: view.width, height: 1)
        
        tableView?.frame = CGRect(x: 0, y: line.bottom, width: view.width, height: view.height - line.bottom - tabBarHeight)
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 0)
        let size = (self.view.width - 61) / 4.5
        layout.itemSize = CGSize(width: size, height: size * 1.5)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        view.addSubview(collectionView!)
    }
    
    private func configureTableView() {
        tableView = UITableView()
        tableView?.allowsSelection = false
        tableView?.separatorStyle = .none
        tableView?.register(PostHeaderTableViewCell.self, forCellReuseIdentifier: PostHeaderTableViewCell.identifier)
        tableView?.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView?.register(PostActionTableViewCell.self, forCellReuseIdentifier: PostActionTableViewCell.identifier)
        tableView?.register(PostTextTableViewCell.self, forCellReuseIdentifier: PostTextTableViewCell.identifier)
        
        if let hasTableView = tableView {
            view.addSubview(hasTableView)
            hasTableView.delegate = self
            hasTableView.dataSource = self
            hasTableView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func configureCell(_ cell: PhotoCollectionViewCell, _ index: Int) {
        // Defualt image
        cell.imageView.image = UIImage(named: "profileImage2")
        
        let username = followingList[index].username
        (cell.subviews.last as! UILabel).text = username
        cell.imageView.setProfileImage(username: username)
        if index == 0 {
            (cell.subviews.last as! UILabel).textColor = .black.withAlphaComponent(0.8)
        } else {
            (cell.subviews.last as! UILabel).textColor = .black.withAlphaComponent(0.5)
        }
    }
    
    private func didTapForLike(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexpath = tableView?.indexPathForRow(at: point) else {
            return
        }
        let index = indexpath.row / 4
        let postId = posts[index].id
        
        guard let logedIn = StorageManager.shared.callUserInfo() else {
            return
        }
        let userId = logedIn.id
        
        DatabaseManager.shared.insertLike(postId: postId, userId: userId) { post in
            if post.id == postId {
                self.posts[index] = post
                DispatchQueue.main.async {
                    if let hasCell = self.tableView?.cellForRow(at: indexpath) {
                        if ((hasCell as? PostActionTableViewCell) != nil) {
                            
                            (self.tableView?.cellForRow(at: IndexPath(row: indexpath.row - 1, section: 0)) as! PostTableViewCell).showEffect()
                            
                            (hasCell as! PostActionTableViewCell).changeLikeButtonToFullHeart()
                            
                            (self.tableView?.cellForRow(at: IndexPath(row: indexpath.row + 1, section: 0)) as! PostTextTableViewCell).configureLikeLabel(usernames: post.likes)
                            (self.tableView?.cellForRow(at: IndexPath(row: indexpath.row + 1, section: 0)) as! PostTextTableViewCell).reassignContentLabelFrame()
                        }
                    }
                }
            }
        }
    }
    
    private func didTapForUnlike(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexpath = tableView?.indexPathForRow(at: point) else {
            return
        }
        let index = indexpath.row / 4
        let postId = posts[index].id
        
        guard let logedIn = StorageManager.shared.callUserInfo() else {
            return
        }
        let userId = logedIn.id
        
        DatabaseManager.shared.deleteLike(postId: postId, userId: userId) { post in
            if post.id == postId {
                self.posts[index] = post
                DispatchQueue.main.async {
                    if let hasCell = self.tableView?.cellForRow(at: indexpath) {
                        if ((hasCell as? PostActionTableViewCell) != nil) {
                            (hasCell as! PostActionTableViewCell).changeLikeButtonToEmptyHeart()
                            (self.tableView?.cellForRow(at: IndexPath(row: indexpath.row + 1, section: 0)) as! PostTextTableViewCell).configureLikeLabel(usernames: post.likes)
                            (self.tableView?.cellForRow(at: IndexPath(row: indexpath.row + 1, section: 0)) as! PostTextTableViewCell).reassignContentLabelFrame()
                        }
                    }
                }
            }
        }
    }
    
    

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return followingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.imageView.frame.size = CGSize(width: cell.width, height: cell.width)
        cell.imageView.layer.cornerRadius = cell.imageView.width / 2
        cell.imageView.backgroundColor = .systemBackground
        
        if cell.subviews.last is UILabel {
            (cell.subviews.last as! UILabel).text = ""
        } else {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = .lightGray
            cell.addSubview(label)
            label.frame = CGRect(x: 0, y: cell.imageView.bottom, width: cell.width, height: 20)
        }
        
        configureCell(cell, indexPath.row)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count * 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row / 4]
        
        if indexPath.row % 4 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PostHeaderTableViewCell.identifier, for: indexPath) as! PostHeaderTableViewCell
            cell.setUsernameAndLocation(username: post.username, location: post.location)
            cell.profileImage.setProfileImage(username: post.username)
            return cell
        }
        if indexPath.row % 4 == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
            let postId = post.id
            let username = post.username
            cell.mainImageView.setPostImage(username: username, postId: postId)
            
            let post = posts[indexPath.row / 4]
            if post.tagPeople.count > 0 {
                cell.configureMentionIconButton()
                cell.tags = post.tagPeople
            }
            return cell
        }
        if indexPath.row % 4 == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PostActionTableViewCell.identifier, for: indexPath) as! PostActionTableViewCell
            cell.addSubViewsAndTargets()
            let post = posts[indexPath.row / 4]
            cell.configureHeartButton(usernames: post.likes)
            cell.delegate = self
            return cell
        }
        if indexPath.row % 4 == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTextTableViewCell.identifier, for: indexPath) as! PostTextTableViewCell
            let post = posts[indexPath.row / 4]
            
            cell.delegate = self
            cell.indexpath = indexPath
            
            cell.configureLikeLabel(usernames: post.likes)
            cell.configureContentLabel(username: post.username, content: post.content)
            
            DatabaseManager.shared.readAllComments(postId: post.id) { comments in
                DispatchQueue.main.async {
                    cell.configureCommentsButton(comments: comments)
                }
            }
            
            cell.configureDayLabel(dayString: post.dayString)
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 4 == 0 {
            return 50
        }
        if indexPath.row % 4 == 1 {
            return view.width - 60
        }
        if indexPath.row % 4 == 2 {
            return 40
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension HomeViewController: PostActionTableViewCellDelegate {
    func didTapHeartButton(_ sender: UIButton) {
        if sender.imageView?.image == UIImage(systemName: "heart") {
            didTapForLike(sender)
        } else if sender.imageView?.image == UIImage(systemName: "heart.fill") {
            didTapForUnlike(sender)
        }
    }
    
    func didTapChatBubbleButton(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexpath = tableView?.indexPathForRow(at: point) else {
            return
        }
        let index = indexpath.row / 4
        let postId = posts[index].id
        
        let commentVC = CommentViewController()
        commentVC.title = "Comments"
        commentVC.postId = postId
        self.navigationController?.pushViewController(commentVC, animated: true)
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    func didTapPaperPlaneButton() {
        
    }
    
    func didTapBookMarkButton() {
        
    }
    
}

extension HomeViewController: PostTextTableViewCellDelegate {
    func didTapCommentsLabel(sender: UIButton) {
        print("call")
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexpath = tableView?.indexPathForRow(at: point) else {
            return
        }
        let index = indexpath.row / 4
        let postId = posts[index].id
        
        let allCommentsVC = AllCommentsViewController()
        allCommentsVC.title = "Comments"
        allCommentsVC.postId = postId
        self.navigationController?.pushViewController(allCommentsVC, animated: true)
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    func resizeCell(_ indexpath: IndexPath) {
        let cell = self.tableView?.cellForRow(at: indexpath)
        
        self.tableView?.beginUpdates()
        cell?.sizeToFit()
        self.tableView?.endUpdates()
    }
    
    func didTapReadmoreButton(sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexpath = tableView?.indexPathForRow(at: point) else {
            return
        }
        guard let hasCell = self.tableView?.cellForRow(at: indexpath), ((hasCell as? PostTextTableViewCell) != nil) else {
            return
        }
        (hasCell as! PostTextTableViewCell).showFullContent()
        resizeCell(indexpath)
    }
    
    
}
