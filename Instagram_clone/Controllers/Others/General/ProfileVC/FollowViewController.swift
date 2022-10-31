
import UIKit

class FollowViewController: UIViewController {
    enum Result: String {
        case success = "1"
        case failure = "0"
    }
    
    var index: Int?     // 0: followers, 1: following
    
    private var data: [User]?
    
    private let searchResultView = SearchResultView()
    
    private let followersButton: UIButton = {
        let button = UIButton()
        button.setTitle("0 followers", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let followingButton: UIButton = {
        let button = UIButton()
        button.setTitle("0 following", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let blueLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    public let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PeopleTableViewCell.self, forCellReuseIdentifier: PeopleTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureNaviBar()
        addSubViews()
        configureButtonsTitle()
        searchResultView.isHidden = true
        
        followersButton.addTarget(self, action: #selector(didTapFollowersButton), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(didTapFollowingButton), for: .touchUpInside)
        
        searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        assignFrames()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureButtonsTitle()
    }
    
    private func configureNaviBar() {
        let titleText = StorageManager.shared.callUserInfo()!.username
        let title = UILabel()
        title.textColor = .black
        title.text = titleText
        title.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: title)
        self.navigationItem.leftItemsSupplementBackButton = true
    }
    
    private func addSubViews() {
        self.view.addSubview(followersButton)
        self.view.addSubview(followingButton)
        self.view.addSubview(blueLine)
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        self.view.addSubview(searchResultView)
    }
    
    private func configureButtonsTitle() {
        let myUserId = StorageManager.shared.callUserInfo()!.id
        DatabaseManager.shared.readFollowingList(myUserId: myUserId) { users in
            DispatchQueue.main.async {
                if self.index == 1 {
                    self.data = users
                    self.tableView.reloadData()
                }
                
                let numberString = users.count.description
                let oldTitle = self.followingButton.titleLabel?.text
                guard let hasOldTitle = oldTitle else {
                    return
                }
                let newTitle = hasOldTitle.prefix(0) + numberString + (oldTitle?.dropFirst(1))!
                let totalString = String(newTitle)
                self.followingButton.setTitle(totalString, for: .normal)
            }
        }
        
        DatabaseManager.shared.readFollowersList(myUserId: myUserId) { users in
            DispatchQueue.main.async {
                if self.index == 0 {
                    self.data = users
                    self.tableView.reloadData()
                }
                
                let numberString = users.count.description
                let oldTitle = self.followersButton.titleLabel?.text
                guard let hasOldTitle = oldTitle else {
                    return
                }
                let newTitle = hasOldTitle.prefix(0) + numberString + (oldTitle?.dropFirst(1))!
                let totalString = String(newTitle)
                self.followersButton.setTitle(totalString, for: .normal)
            }
        }
    }
    
    private func assignFrames() {
        let statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let naviBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0
        
        followersButton.frame = CGRect(x: 0, y: statusHeight + naviBarHeight, width: view.width / 2, height: 40)
        followingButton.frame = CGRect(x: followersButton.right, y: statusHeight + naviBarHeight, width: view.width / 2, height: 40)
        
        let blackLine = UIView()
        blackLine.backgroundColor = .systemGray.withAlphaComponent(0.3)
        view.addSubview(blackLine)
        blackLine.frame = CGRect(x: 0, y: followersButton.bottom - 1, width: view.width, height: 1)
        self.drawBlueLine()
        
        searchBar.frame = CGRect(x: 0, y: blackLine.bottom + 10, width: view.width, height: 40)
        tableView.frame = CGRect(x: 0, y: searchBar.bottom + 20, width: view.width, height: view.height - searchBar.bottom - 20 - tabBarHeight)
        
        searchResultView.frame = CGRect(x: 0, y: self.searchBar.bottom, width: self.view.width, height: self.view.height - self.searchBar.bottom - tabBarHeight)
    }
    
    @objc private func didTapFollowersButton() {
        self.index = 0
        drawBlueLine()
        configureButtonsTitle()
        
        if !self.searchResultView.isHidden {
            self.searchBar.text = ""
            self.searchBar.endEditing(true)
            self.searchResultView.isHidden = true
        }
    }
    
    @objc private func didTapFollowingButton() {
        self.index = 1
        drawBlueLine()
        configureButtonsTitle()
        
        if !self.searchResultView.isHidden {
            self.searchBar.text = ""
            self.searchBar.endEditing(true)
            self.searchResultView.isHidden = true
        }
    }
    
    private func drawBlueLine() {
        if let hasIndex = self.index {
            if hasIndex == 0 {
                self.blueLine.frame = CGRect(x: 0, y: followersButton.bottom - 1, width: followersButton.width, height: 1)
                self.followersButton.setTitleColor(.systemBlue, for: .normal)
                self.followingButton.setTitleColor(.black, for: .normal)
            } else {
                self.blueLine.frame = CGRect(x: followersButton.right, y: followersButton.bottom - 1, width: followersButton.width, height: 1)
                self.followingButton.setTitleColor(.systemBlue, for: .normal)
                self.followersButton.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexpath = tableView.indexPathForRow(at: point) else {
            return
        }
        guard let hasData = self.data else {
            return
        }
        
        let user = hasData[indexpath.row]
        
        let buttonTitle = sender.titleLabel?.text!
        if buttonTitle == "Following" {
            showUnfollowMenuSheet(user, indexpath)
        } else if buttonTitle == "Follow" {
            refollow(theOtherUserId: user.id, indexPath: indexpath)
        } else if buttonTitle == "Remove" {
            showRemoveMenuSheet(user, indexpath)
        }
        
    }
    
    public func refollow(theOtherUserId: Int, indexPath: IndexPath) {
        let myUserId = StorageManager.shared.callUserInfo()!.id
        DatabaseManager.shared.insertFollowing(myUserId: myUserId, followToUserId: theOtherUserId) { result in
            if result == "1" {
                DispatchQueue.main.async {
                    if !self.searchResultView.isHidden {
                        let parentIndexPathRow = self.searchResultView.changeToFollowingButton(indexPath)
                        if parentIndexPathRow >= 0 {
                            let parentIndexPath = IndexPath(row: parentIndexPathRow, section: 0)
                            self.changeToFollowingButton(parentIndexPath)
                            self.changeFollowingNumber(1)
                        }
                    } else {
                        self.changeToFollowingButton(indexPath)
                        self.changeFollowingNumber(1)
                    }
                }
            }
        }
    }
    
    public func showRemoveMenuSheet(_ user: User, _ indexPath: IndexPath) {
        let removeSheet = RemoveMenuView()
        removeSheet.user = user
        removeSheet.indexPath = indexPath
        removeSheet.customedDelegate2 = self
        self.tabBarController?.view.addSubview(removeSheet)
        
        removeSheet.frame = CGRect(x: 0, y: view.height, width: view.width, height: 0)
        
        UIView.animate(withDuration: 0.5,
                         delay: 0, usingSpringWithDamping: 1.0,
                         initialSpringVelocity: 1.0,
                         options: .curveEaseInOut, animations: {
            removeSheet.frame = self.view.bounds
          }, completion: nil)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    public func showUnfollowMenuSheet(_ user: User, _ indexPath: IndexPath) {
        let unfollowSheet = UnfollowMenuView()
        unfollowSheet.user = user
        unfollowSheet.indexPath = indexPath
        unfollowSheet.customedDelegate = self
        self.tabBarController?.view.addSubview(unfollowSheet)
        
        unfollowSheet.frame = CGRect(x: 0, y: view.height, width: view.width, height: 0)
        
        UIView.animate(withDuration: 0.5,
                         delay: 0, usingSpringWithDamping: 1.0,
                         initialSpringVelocity: 1.0,
                         options: .curveEaseInOut, animations: {
            unfollowSheet.frame = self.view.bounds
          }, completion: nil)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func searchInData(_ keyword: String) -> [Int: User] {
        var users = Dictionary<Int, User>()
        guard let hasData = self.data else {
            return users
        }
        let result = hasData.map( { $0.username.contains(keyword) } )
        guard result.count > 0 else {
            return users
        }
        for i in 0..<result.count {
            if result[i] {
                users[i] = hasData[i]
            }
        }
        return users
    }
    
    private func changeToFollowButton(_ indexPath: IndexPath) {
        var cellButton: UIButton?
        let cell = self.tableView.cellForRow(at: indexPath)
        if let hasCell = cell {
            let subViewArray = hasCell.subviews
            for subView in subViewArray {
                if let button = subView as? UIButton {
                    cellButton = button
                    cellButton!.setTitle("Follow", for: .normal)
                    cellButton!.setTitleColor(.white, for: .normal)
                    cellButton!.backgroundColor = .systemBlue
                }
            }
        }
    }
    
    private func changeToFollowingButton(_ indexPath: IndexPath) {
        var cellButton: UIButton?
        let cell = self.tableView.cellForRow(at: indexPath)
        if let hasCell = cell {
            let subViewArray = hasCell.subviews
            for subView in subViewArray {
                if let button = subView as? UIButton {
                    cellButton = button
                    cellButton!.setTitle("Following", for: .normal)
                    cellButton!.setTitleColor(.black, for: .normal)
                    cellButton!.backgroundColor = .systemBackground
                }
            }
        }
    }
    
    private func changeFollowingNumber(_ number: Int) {
        let oldTitle = self.followingButton.titleLabel?.text
        guard let hasOldTitle = oldTitle else {
            return
        }
        let oldNumberString = (hasOldTitle.components(separatedBy: " ").first!)
        let oldNumber = Int(oldNumberString)!
        let newNumberString = (oldNumber + number).description
        let newTitle = hasOldTitle.prefix(0) + newNumberString + (oldTitle?.dropFirst(1))!
        let totalString = String(newTitle)
        self.followingButton.setTitle(totalString, for: .normal)
    }
    
    private func changeFollowersNumber(_ number: Int) {
        let oldTitle = self.followersButton.titleLabel?.text
        guard let hasOldTitle = oldTitle else {
            return
        }
        let oldNumberString = (hasOldTitle.components(separatedBy: " ").first!)
        let oldNumber = Int(oldNumberString)!
        let newNumberString = (oldNumber + number).description
        let newTitle = hasOldTitle.prefix(0) + newNumberString + (oldTitle?.dropFirst(1))!
        let totalString = String(newTitle)
        self.followersButton.setTitle(totalString, for: .normal)
    }
    
    private func removeFollowerCell(_ indexPath: IndexPath) {
        self.data!.remove(at: indexPath.row)
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: [indexPath], with: .left)
        self.tableView.endUpdates()
        
        changeFollowersNumber(-1)
    }
    
    private func removeFollowerCellByObject(_ userId: Int) {
        var row = -1
        for i in 0..<self.data!.count {
            if self.data![i].id == userId {
                row = i
            }
        }
        if row >= 0 {
            let indexPath = IndexPath(row: row, section: 0)
            removeFollowerCell(indexPath)
        }
    }
    
    
}
extension FollowViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            self.searchResultView.index = self.index!
            self.searchResultView.isHidden = false
            let result = searchInData(searchText)
            if result.isEmpty {
                self.searchResultView.data?.removeAll()
                self.searchResultView.reloadTableView()
            } else {
                self.searchResultView.data = result
                self.searchResultView.reloadTableView()
            }
        } else {
            self.searchResultView.isHidden = true
        }
    }
}

extension FollowViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PeopleTableViewCell.identifier, for: indexPath) as! PeopleTableViewCell
        
        if self.index == 1 {
            if cell.subviews.count > 2 {
                var cellButton: UIButton?
                let cell = self.tableView.cellForRow(at: indexPath)
                if let hasCell = cell {
                    let subViewArray = hasCell.subviews
                    for subView in subViewArray {
                        if let button = subView as? UIButton {
                            cellButton = button
                            cellButton?.removeFromSuperview()
                        }
                    }
                }
            }
            
            let followingButton = UIButton()
            followingButton.setTitle("Following", for: .normal)
            followingButton.backgroundColor = .systemBackground
            followingButton.setTitleColor(.black, for: .normal)
            followingButton.layer.borderColor = UIColor.lightGray.cgColor
            followingButton.layer.borderWidth = 1
            followingButton.layer.cornerRadius = 5
            cell.addSubview(followingButton)
            followingButton.frame = CGRect(x: self.view.width * 0.6, y: 15, width: 120, height: 30)
            followingButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        } else {
            if cell.subviews.count > 2 {
                var cellButton: UIButton?
                let cell = self.tableView.cellForRow(at: indexPath)
                if let hasCell = cell {
                    let subViewArray = hasCell.subviews
                    for subView in subViewArray {
                        if let button = subView as? UIButton {
                            cellButton = button
                            cellButton?.removeFromSuperview()
                        }
                    }
                }
            }
                
                let removeButton = UIButton()
                removeButton.setTitle("Remove", for: .normal)
                removeButton.backgroundColor = .systemBackground
                removeButton.setTitleColor(.black, for: .normal)
                removeButton.layer.borderColor = UIColor.lightGray.cgColor
                removeButton.layer.borderWidth = 1
                removeButton.layer.cornerRadius = 5
                cell.addSubview(removeButton)
                removeButton.frame = CGRect(x: self.view.width * 0.6, y: 15, width: 120, height: 30)
                removeButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        }
        
        guard let hasData = self.data else {
            return cell
        }
        let user = hasData[indexPath.row]
        cell.configureUsername(user.username)
        cell.profileImageView.image = UIImage(named: "profileImage2")
        cell.profileImageView.setProfileImage(username: user.username)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FollowViewController: UnfollowMenuViewDelegate {
    func didTapUnfollowButton(_ user: User, _ indexPath: IndexPath) {
        let myUserId = StorageManager.shared.callUserInfo()!.id
        DatabaseManager.shared.unfollowToUser(myUserId: myUserId, theOtherUserId: user.id) { result in
            if result == Result.success.rawValue {
                DispatchQueue.main.async {
                    if !self.searchResultView.isHidden {
                        let parentIndexPathRow = self.searchResultView.changeToFollowButton(indexPath)
                        if parentIndexPathRow >= 0 {
                            let parentIndexPath = IndexPath(row: parentIndexPathRow, section: 0)
                            self.changeToFollowButton(parentIndexPath)
                            self.changeFollowingNumber(-1)
                            self.didTapCancelButton()
                        }
                    } else {
                        self.changeToFollowButton(indexPath)
                        self.changeFollowingNumber(-1)
                        self.didTapCancelButton()
                    }
                }
            }
        }
        
    }
    
    func didTapCancelButton() {
        self.tabBarController?.view.subviews.last!.removeFromSuperview()
        self.tabBarController?.tabBar.isHidden = false
    }
    
}

extension FollowViewController: RemoveMenuViewDelegate {
    func didTapRemoveButton(_ user: User, _ indexPath: IndexPath) {
        let myUserId = StorageManager.shared.callUserInfo()!.id
        let theOtherUserId = user.id
        DatabaseManager.shared.removeFollower(myUserId: myUserId, theOtherUserId: theOtherUserId) { result in
            if result == Result.success.rawValue {
                DispatchQueue.main.async {
                    if !self.searchResultView.isHidden {
                            self.didTapCancelButton()
                            self.searchResultView.removeFollowerCell(indexPath)
                            self.removeFollowerCellByObject(theOtherUserId)
                    } else {
                        self.didTapCancelButton()
                        self.removeFollowerCell(indexPath)
                    }
                }
            }
          }
        }
    
    
}

