
import UIKit

class SharePostView: UIView {
    
    var post: Post?
    
    private var isExpand = false
    private var keyboardHeight: CGFloat = 0
    
    private var minY: CGFloat = 0
    
    private var data: [User]?
    
    private var coreData: [User]?
    
    private lazy var shareUserList = [User]()
    
    private let gestureButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = UIColor(red: 225/250, green: 225/250, blue: 226/250, alpha: 1.0)
        button.frame.size = CGSize(width: 50, height: 5)
        return button
    }()
    
    private let searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        return searchBar
    }()
    
    private var tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(PeopleTableViewCell.self, forCellReuseIdentifier: PeopleTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let sendButton: UIButton = {
       let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.backgroundColor = UIColor(red: 225/250, green: 225/250, blue: 226/250, alpha: 1.0)
        button.tintColor = .white
        button.isEnabled = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        addSubviews()
        configureGestureRecognizer()
        configureData()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        sendButton.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardAppear(_ notification: Notification) {
        if !isExpand {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                keyboardHeight = keyboardRectangle.height
                isExpand = true
                layoutSubviews()
                sendButton.isHidden = true
            }
        }
    }
    
    @objc func keyboardDisappear() {
        if isExpand {
            isExpand = false
            layoutSubviews()
            sendButton.isHidden = false
        }
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        assignframes()
    }
    
    private func configureData() {
        let myUserId = StorageManager.shared.callUserInfo()!.id
        DatabaseManager.shared.readFollowersList(myUserId: myUserId) { users in
            var userList = [User]()
            userList.append(contentsOf: users)
            for i in 0..<users.count {
                if users[i].username == self.post!.username {
                    userList.remove(at: i)
                }
            }
            self.data = userList
            self.coreData = userList
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func configureGestureRecognizer() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPanGestureButton))
        gestureButton.addGestureRecognizer(pan)
        
        let tab = UITapGestureRecognizer(target: self, action: #selector(didTapSelf))
        self.addGestureRecognizer(tab)
    }
    
    @objc func didTapSelf() {
        searchBar.resignFirstResponder()
    }
    
    @objc func didPanGestureButton(_ sender: UIPanGestureRecognizer) {
        searchBar.resignFirstResponder()
        
        let diff = sender.translation(in: self)
        
        if sender.state == .changed {
            self.frame.origin.y += diff.y
            
            if self.frame.origin.y < minY {
                self.frame.origin.y = minY
            }
            
            sender.setTranslation(CGPoint.zero, in: self)
        } else if sender.state == .ended || sender.state == .cancelled {
            if self.frame.origin.y < minY + self.height / 2 {
                self.frame.origin.y = minY
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.frame.origin.y = self.bottom
                } completion: { bool in
                    if bool {
                        self.superview?.removeFromSuperview()
                        self.removeFromSuperview()
                        return
                    }
                }
            }
        }
    }
    
    private func addSubviews() {
        self.addSubview(gestureButton)
        self.addSubview(searchBar)
        self.addSubview(tableView)
        self.addSubview(sendButton)
    }

    public func assignframes() {
            
        if isExpand {
            var frame = tableView.frame
            frame.size.height = 126
            tableView.frame = frame
        } else {
            gestureButton.center = CGPoint(x: self.width / 2, y: 15 + gestureButton.height / 2)
            searchBar.frame = CGRect(x: 10, y: gestureButton.bottom + 5, width: self.width - 20, height: 50)
            sendButton.frame = CGRect(x: 0, y: self.height - 50, width: self.width, height: 50)
            tableView.frame = CGRect(x: 0, y: searchBar.bottom + 5, width: self.width, height: self.height - sendButton.height - 10 - searchBar.bottom - 5)
            minY = self.top
        }
    }
    
    @IBAction func didTapSelectButton(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexpath = tableView.indexPathForRow(at: point) else {
            return
        }
        guard let hasData = data else {
            return
        }
        let user = hasData[indexpath.row]
        
        if sender.backgroundImage(for: .normal) == UIImage(systemName: "circle") {
            sender.setBackgroundImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
            sender.tintColor = .systemBlue
            shareUserList.append(user)
            
        } else if sender.backgroundImage(for: .normal) == UIImage(systemName: "circle.circle.fill") {
            sender.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
            sender.tintColor = UIColor(red: 225/250, green: 225/250, blue: 226/250, alpha: 1.0)
            for i in 0..<shareUserList.count {
                if shareUserList[i].id == user.id {
                    shareUserList.remove(at: i)
                    break
                }
            }
        }
        sendButtonIsEnable()
    }
    
    private func sendButtonIsEnable() {
        let count = shareUserList.count
        if count > 0 {
            sendButton.backgroundColor = .systemBlue
            sendButton.isEnabled = true
        } else {
            sendButton.backgroundColor = UIColor(red: 225/250, green: 225/250, blue: 226/250, alpha: 1.0)
            sendButton.isEnabled = false
        }
    }
    
    @objc func didTapSendButton() {
        let mySelf = StorageManager.shared.callUserInfo()!
        let myUserId = mySelf.id
        let content = "Post Share:"
        let dayString = Date().description
        let postId = post!.id
        
        var messages = [Message]()
        
        for user in shareUserList {
            let userId = user.id
            let message = Message(id: 0, senderId: myUserId, recipientId: userId, content: content, dayString: dayString, postId: postId)
            messages.append(message)
        }
        
        for message in messages {
            DatabaseManager.shared.insertMessage(message: message) { result in
                if result == Result.success.rawValue {
                    DispatchQueue.main.async {
                        self.superview?.removeFromSuperview()
                        self.removeFromSuperview()
                        // show success notice
                    }
                } else {
                    fatalError("fail")
                }
            }
        }
        
    }
}

extension SharePostView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let lowerKeyword = searchText.lowercased()
        guard let hasData = data else {
            return
        }
        var list = [User]()
        for entity in hasData {
            if entity.username.contains(lowerKeyword) {
                list.append(entity)
            }
        }
        if !list.isEmpty {
            data = list
        } else {
            data = coreData
        }
        tableView.reloadData()
    }
}

extension SharePostView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PeopleTableViewCell.identifier, for: indexPath) as! PeopleTableViewCell
        cell.index = 1
        guard let hasData = data else {
            return cell
        }
        let username = hasData[indexPath.row].username
        cell.profileImageView.setProfileImage(username: username)
        cell.configureUsername(username)
        
        let selectButton = UIButton()
        selectButton.tintColor = UIColor(red: 225/250, green: 225/250, blue: 226/250, alpha: 1.0)
        selectButton.addTarget(self, action: #selector(didTapSelectButton), for: .touchUpInside)
        selectButton.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        
        for subview in cell.subviews {
            if let hasButton = subview as? UIButton {
                for user in shareUserList {
                    if user.username == username {
                        hasButton.setBackgroundImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
                        hasButton.tintColor = .systemBlue
                        return cell
                    }
                }
                hasButton.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
                hasButton.tintColor = UIColor(red: 225/250, green: 225/250, blue: 226/250, alpha: 1.0)
                return cell
            }
        }
        
        cell.addSubview(selectButton)
        let size: CGFloat = 25
        selectButton.frame = CGRect(x: self.width - 20 - size, y: (cell.height - size)/2, width: size, height: size)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
