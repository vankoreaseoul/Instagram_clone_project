
import UIKit

class SearchResultView: UIView {
    
    var index = 0 // 0: followers, 1: following
    
    var data: [Int: User]?
    
    var coreData: [User]?
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(PeopleTableViewCell.self, forCellReuseIdentifier: PeopleTableViewCell.identifier)
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(tableView)
        tableView.frame = self.bounds
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public func reloadTableView() {
        if let hasData = data {
            coreData = Array(hasData.values)
        }
        self.tableView.reloadData()
    }
    
    public func changeToFollowButton(_ indexPath: IndexPath) -> Int {
        var followingButton: UIButton?
        let cell = self.tableView.cellForRow(at: indexPath)
        if let hasCell = cell {
            let subViewArray = hasCell.subviews
            for subView in subViewArray {
                if let button = subView as? UIButton {
                    followingButton = button
                }
            }
        }
        
        guard let hasButton = followingButton else {
            return -1
        }
        
        hasButton.setTitle("Follow", for: .normal)
        hasButton.setTitleColor(.white, for: .normal)
        hasButton.backgroundColor = .systemBlue
        
        guard let hasCoreData = self.coreData else {
            return -1
        }
        let user = hasCoreData[indexPath.row]
        
        guard let hasData = self.data else {
            return -1
        }
        for key in hasData.keys {
            if hasData[key]!.id == user.id {
                return key
            }
        }
        return -1
    }
    
    public func findParentIndexPath(_ childIndexPath: IndexPath) -> Int {
        guard let hasCoreData = self.coreData else {
            return -1
        }
        let user = hasCoreData[childIndexPath.row]
        
        guard let hasData = self.data else {
            return -1
        }
        for key in hasData.keys {
            if hasData[key]!.id == user.id {
                return key
            }
        }
        return -1
    }
    
    public func removeFollowerCell(_ indexPath: IndexPath) {
        self.coreData!.remove(at: indexPath.row)
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: [indexPath], with: .left)
        self.tableView.endUpdates()
    }
    
    public func changeToFollowingButton(_ indexPath: IndexPath) -> Int {
        var followButton: UIButton?
        let cell = self.tableView.cellForRow(at: indexPath)
        if let hasCell = cell {
            let subViewArray = hasCell.subviews
            for subView in subViewArray {
                if let button = subView as? UIButton {
                    followButton = button
                }
            }
        }
        
        guard let hasButton = followButton else {
            return -1
        }
        
        hasButton.setTitle("Following", for: .normal)
        hasButton.setTitleColor(.black, for: .normal)
        hasButton.backgroundColor = .systemBackground
        
        guard let hasCoreData = self.coreData else {
            return -1
        }
        let user = hasCoreData[indexPath.row]
        
        guard let hasData = self.data else {
            return -1
        }
        for key in hasData.keys {
            if hasData[key]!.id == user.id {
                return key
            }
        }
        return -1
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        (self.superview?.next as! FollowViewController).searchBar.resignFirstResponder()
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexpath = tableView.indexPathForRow(at: point) else {
            return
        }
        guard let hasCoreData = self.coreData else {
            return
        }
        
        let user = hasCoreData[indexpath.row]
        
        let buttonTitle = sender.titleLabel?.text!
        if buttonTitle == "Following" {
            (self.superview?.next as! FollowViewController).showUnfollowMenuSheet(user, indexpath)
        } else if buttonTitle == "Follow" {
            (self.superview?.next as! FollowViewController).refollow(theOtherUserId: user.id, indexPath: indexpath)
        } else if buttonTitle == "Remove" {
            (self.superview?.next as! FollowViewController).showRemoveMenuSheet(user, indexpath)
        }
        
    }
    
}

extension SearchResultView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PeopleTableViewCell.identifier, for: indexPath) as! PeopleTableViewCell
        
        if let hasCoreData = coreData {
            let user = hasCoreData[indexPath.row]
            let username = user.username
            cell.configureUsername(username)
            cell.profileImageView.image = UIImage(named: "profileImage2")
            cell.profileImageView.setProfileImage(username: username)
           
            if index == 1 {
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
                
                var userIdList = [Int]()
                DatabaseManager.shared.readFollowingList(myUserId: StorageManager.shared.callUserInfo()!.id) { users in
                    DispatchQueue.main.async {
                        for user in users {
                            userIdList.append(user.id)
                        }
                        if !userIdList.contains(hasCoreData[indexPath.row].id) {
                            followingButton.setTitle("Follow", for: .normal)
                            followingButton.backgroundColor = .systemBlue
                            followingButton.setTitleColor(.white, for: .normal)
                        }
                    }
                }
                
                
                cell.addSubview(followingButton)
                followingButton.frame = CGRect(x: self.width * 0.6, y: 15, width: 120, height: 30)
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
                removeButton.frame = CGRect(x: self.width * 0.6, y: 15, width: 120, height: 30)
                removeButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

