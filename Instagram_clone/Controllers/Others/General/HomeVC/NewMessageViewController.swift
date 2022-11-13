
import UIKit

class NewMessageViewController: MessageSearchViewController {
    
    private var chatCounterpart: String?     // username
    private var data: [String]?             // username
    private var coreData: [String]?         // username
    
    private let toLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.text = "To"
        label.textColor = .black
        return label
    }()
    
    private let suggestedLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.text = "Suggested"
        label.textColor = .black
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(toLabel)
        view.addSubview(suggestedLabel)
        searchBar.setImage(UIImage(), for: .search, state: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.text = nil
        chatCounterpart = nil
        chatButtonIsEnable()
        configureData()
        resetSelectButton()
    }
    
    override func configureNaviBar() {
        self.naviBarLabel.text = "New Message"
        naviBarLabel.sizeToFit()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Chat", style: .plain, target: self, action: #selector(didTapChatButton))
        navigationItem.rightBarButtonItem?.tintColor = .systemGray
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    override func assignFrames() {
        let statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let naviBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        
        naviBarLabel.frame.origin.x = (self.view.width - naviBarLabel.width) / 2
        naviBarLabel.frame.origin.y = (naviBarHeight - naviBarLabel.frame.size.height) / 2 + statusHeight
        naviBarLine.frame = CGRect(x: 0, y: statusHeight + naviBarHeight, width: view.width, height: 1)
        toLabel.frame = CGRect(x: 10, y: naviBarLine.bottom + 10, width: 40, height: 30)
        toLabel.sizeToFit()
        searchBar.frame = CGRect(x: 0, y: toLabel.bottom + 10, width: view.width, height: 50)
        suggestedLabel.frame = CGRect(x: 10, y: searchBar.bottom + 20, width: 80, height: 30)
        suggestedLabel.sizeToFit()
        tableView.frame = CGRect(x: 0, y: suggestedLabel.bottom + 10, width: view.width, height: view.height - suggestedLabel.bottom)
    }
    
    private func chatButtonIsEnable() {
        if chatCounterpart != nil {
            navigationItem.rightBarButtonItem?.isEnabled = true
            navigationItem.rightBarButtonItem?.tintColor = .systemBlue
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationItem.rightBarButtonItem?.tintColor = .systemGray
        }
    }
    
    private func resetSelectButton() {
        guard let hasData = data else {
            return
        }
        guard hasData.count != 0 else {
            return
        }
        for i in 0..<hasData.count {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0))!
            for subview in cell.subviews {
                if let button = subview as? UIButton {
                    button.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
                    button.tintColor = UIColor(red: 225/250, green: 225/250, blue: 226/250, alpha: 1.0)
                }
            }
        }
    }
    
    override func configureData() {
        let userId = StorageManager.shared.callUserInfo()!.id
        
        DatabaseManager.shared.readAllFollowsAndFollowers(myUserId: userId) { users in
            DispatchQueue.main.async {
                self.data = users.map( { return $0.username } )
                self.coreData = users.map( { return $0.username } )
                self.tableView.reloadData()
            }
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
        let username = hasData[indexpath.row]
        
        if sender.backgroundImage(for: .normal) == UIImage(systemName: "circle") {
            sender.setBackgroundImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
            sender.tintColor = .systemBlue
            
            if chatCounterpart == nil {
                chatCounterpart = username
            } else {
                for i in 0..<hasData.count {
                    if hasData[i] == chatCounterpart! {
                        let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0))!
                        for subview in cell.subviews {
                            if subview is UIButton {
                                (subview as! UIButton).setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
                                (subview as! UIButton).tintColor = UIColor(red: 225/250, green: 225/250, blue: 226/250, alpha: 1.0)
                            }
                        }
                    }
                }
                chatCounterpart = username
            }
            
        } else if sender.backgroundImage(for: .normal) == UIImage(systemName: "circle.circle.fill") {
            sender.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
            sender.tintColor = UIColor(red: 225/250, green: 225/250, blue: 226/250, alpha: 1.0)
            chatCounterpart = nil
        }
        chatButtonIsEnable()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostHeaderTableViewCell.identifier, for: indexPath) as! PostHeaderTableViewCell
        cell.index = 2
        
        guard let hasData = data else {
            return cell
        }
        
        let username = hasData[indexPath.row]
        cell.profileImage.setProfileImage(username: username)
        cell.setUsernameAndLocation(username: username, location: "", time: "")
        
        let selectButton = UIButton()
        selectButton.tintColor = UIColor(red: 225/250, green: 225/250, blue: 226/250, alpha: 1.0)
        selectButton.addTarget(self, action: #selector(didTapSelectButton), for: .touchUpInside)
        selectButton.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        
        for subview in cell.subviews {
            if subview as? UIButton != nil {
                return cell
            }
        }
        
        cell.addSubview(selectButton)
        let size: CGFloat = 25
        selectButton.frame = CGRect(x: self.view.width - 20 - size, y: (cell.height - size)/2, width: size, height: size)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.data = self.coreData
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.suggestedLabel.text = "Suggested"
                self.reconfigureSelectButton()
                self.reconfigureChatCounterpart()
            }
            return
        }
        
        DatabaseManager.shared.searchUsers(username: searchText) { list in
            var usernames = list.map( { return $0.0 } )
            for i in 0..<usernames.count {
                if usernames[i] == StorageManager.shared.callUserInfo()!.username {
                    usernames.remove(at: i)
                }
            }
            if !usernames.isEmpty {
                self.data = usernames
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.suggestedLabel.text = "Searching.."
                    self.suggestedLabel.sizeToFit()
                    self.reconfigureSelectButton()
                    self.reconfigureChatCounterpart()
                }
            } else {
                self.data = self.coreData
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.suggestedLabel.text = "Suggested"
                    self.reconfigureSelectButton()
                    self.reconfigureChatCounterpart()
                }
            }
        }
    }

    private func reconfigureSelectButton() {
        guard let hasData = data else {
            return
        }
        for i in 0..<hasData.count {
            if chatCounterpart != nil && hasData[i] == chatCounterpart {
                let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0))!
                for subview in cell.subviews {
                    if subview is UIButton {
                        (subview as! UIButton).setBackgroundImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
                        (subview as! UIButton).tintColor = .systemBlue
                    }
                }
            } else {
                let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0))!
                for subview in cell.subviews {
                    if subview is UIButton {
                        (subview as! UIButton).setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
                        (subview as! UIButton).tintColor = UIColor(red: 225/250, green: 225/250, blue: 226/250, alpha: 1.0)
                    }
                }
            }
        }
    }
    
    private func reconfigureChatCounterpart() {
        guard chatCounterpart != nil else {
            return
        }
        let count = self.data?.count ?? 0
        if count == 0 {
            return
        }
        var result = 0
        for i in 0..<count {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0))!
            for subview in cell.subviews {
                if subview is UILabel {
                    if (subview as? UILabel)?.text == chatCounterpart {
                        result = 1
                        break
                    }
                }
            }
        }
        if result == 0 {
            chatCounterpart = nil
            chatButtonIsEnable()
        }
    }
    
    @objc func didTapChatButton() {
        let username = chatCounterpart!
        DatabaseManager.shared.readUser(username: username, email: nil) { user in
            DispatchQueue.main.async {
                let messageVC = MessageViewController()
                messageVC.user = user
                self.navigationController?.pushViewController(messageVC, animated: true)
                self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
            }
        }
    }
}

