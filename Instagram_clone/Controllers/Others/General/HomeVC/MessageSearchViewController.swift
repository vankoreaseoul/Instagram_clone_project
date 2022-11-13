
import UIKit

class MessageSearchViewController: UIViewController {
    
    public var users: [User]?
    private var lastMessages: [Message]?
    public var coreUsers: [User]?
    private var coreLastMessages: [Message]?
    public var isExpand = false
    
    public let naviBarLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    public let naviBarLine: UIView = {
       let view = UIView()
        view.backgroundColor = .systemGray.withAlphaComponent(0.3)
        return view
    }()
    
    public let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        searchBar.placeholder = "Search"
        return searchBar
    }()
    
    public let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubViews()
        configureNaviBar()
        configureData()
        configureTableView()
        configureGestureRecognizer()
        searchBar.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tabBarController?.tabBar.isHidden = true
        assignFrames()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.text = nil
        configureData()
    }
    
    @objc func keyboardAppear(_ notification: Notification) {
        if !isExpand {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                
                view.frame.size.height = view.height - keyboardHeight
                isExpand = true
            }
        }
    }
    
    @objc func keyboardDisappear() {
        if isExpand {
            view.frame.size.height = UIScreen.main.bounds.size.height
            isExpand = false
        }
    }
    
    private func configureGestureRecognizer() {
        let tab = UITapGestureRecognizer(target: self, action: #selector(didTapSelf))
        tab.cancelsTouchesInView = false
        view.addGestureRecognizer(tab)
    }
    
    @objc func didTapSelf(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    
    private func addSubViews() {
        view.addSubview(naviBarLabel)
        view.addSubview(naviBarLine)
        view.addSubview(searchBar)
    }
    
    public func configureNaviBar() {
        naviBarLabel.text = StorageManager.shared.callUserInfo()?.username
        naviBarLabel.sizeToFit()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(didTapNewMessageRoom))
    }
    
    public func configureData() {
        let myUserId = StorageManager.shared.callUserInfo()!.id
        DatabaseManager.shared.readAllMessageCounterparts(myUserId: myUserId) { users in
            self.configureLastWord(users)
            self.users = users
        }
        
    }
    
    private func configureLastWord(_ users: [User]) {
        let userIdList = users.map( { return $0.id} )
        let myUserId = StorageManager.shared.callUserInfo()!.id
        DatabaseManager.shared.readLastMessage(senderId: myUserId, recipientIdList: userIdList) { messages in
            self.reconfigureData(messages)
        }
    }
    
    private func reconfigureData(_ messages: [Message]) {
        let myUserId = StorageManager.shared.callUserInfo()!.id
        var userIdList = [Int]()
        var userList = [User]()
        
        for message in messages {
            let senderId = message.senderId
            let recipientId = message.recipientId
            
            if senderId == myUserId {
                userIdList.append(recipientId)
            } else {
                userIdList.append(senderId)
            }
        }
        
        if !userIdList.isEmpty {
            for userId in userIdList {
                for user in self.users! {
                    if userId == user.id {
                        userList.append(user)
                    }
                }
            }
        }
        
        DispatchQueue.main.async {
            self.users = userList
            self.coreUsers = userList
            self.lastMessages = messages
            self.coreLastMessages = messages
            self.tableView.reloadData()
        }
    }
    
    private func configureTableView() {
        tableView.register(PostHeaderTableViewCell.self, forCellReuseIdentifier: PostHeaderTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    @objc func didTapNewMessageRoom() {
        let newMessageVC = NewMessageViewController()
        self.navigationController?.pushViewController(newMessageVC, animated: true)
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    
    public func assignFrames() {
        let statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let naviBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        
        naviBarLabel.frame.origin.x = (self.view.width - naviBarLabel.width) / 2
        naviBarLabel.frame.origin.y = (naviBarHeight - naviBarLabel.frame.size.height) / 2 + statusHeight
        naviBarLine.frame = CGRect(x: 0, y: statusHeight + naviBarHeight, width: view.width, height: 1)
        searchBar.frame = CGRect(x: 0, y: naviBarLine.bottom, width: view.width, height: 50)
        tableView.frame = CGRect(x: 0, y: searchBar.bottom, width: view.width, height: view.height - searchBar.bottom)
    }
 

}

extension MessageSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let hasUsers = users else {
            return
        }
        
        var userList = [User]()
        var messageList = [Message]()
        for i in 0..<hasUsers.count {
            if hasUsers[i].username.contains(searchText) {
                userList.append(hasUsers[i])
                messageList.append(coreLastMessages![i])
            }
        }
        
        if !userList.isEmpty {
            self.users = userList
            self.lastMessages = messageList
            self.tableView.reloadData()
        } else {
            self.users = coreUsers
            self.lastMessages = coreLastMessages
            self.tableView.reloadData()
        }
    }
}

extension MessageSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostHeaderTableViewCell.identifier, for: indexPath) as! PostHeaderTableViewCell
        cell.index = 1
        
        guard let hasUsers = users, let hasMessages = lastMessages else {
            return cell
        }
        
        let user = hasUsers[indexPath.row]
        let username = user.username
        let lastMessage = hasMessages[indexPath.row].content
        let time = hasMessages[indexPath.row].dayString
        cell.profileImage.setProfileImage(username: username)
        cell.setUsernameAndLocation(username: username, location: lastMessage, time: time)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let hasUsers = users else {
            return
        }
        
        let messageVC = MessageViewController()
        messageVC.user = hasUsers[indexPath.row]
        self.navigationController?.pushViewController(messageVC, animated: true)
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
}

