
import UIKit

class MessageViewController: UIViewController {
    
    var user: User?
    
    var data: [Message]?
    
    var isExpand = false
    
    private let topLine: UIView = {
       let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.3)
        view.frame.size.height = 1
        return view
    }()
    
    private let tableView = UITableView()
    
    private let textBackgroundView: UIView = {
       let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let textBox: UIView = {
       let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 22
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        return view
    }()
    
    private let cameraButton: UIButton = {
       let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "camera.circle.fill"), for: .normal)
        button.tintColor = .systemCyan
        return button
    }()
    
    private let galleryButton: UIButton = {
       let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "photo"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let textView: UITextView = {
       let textView = UITextView()
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.font = .systemFont(ofSize: 17)
        textView.text = "Message..."
        textView.textColor = .systemGray
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.returnKeyType = .send
        textView.enablesReturnKeyAutomatically = true
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNaviBar()
        addSubViews()
        addTargets()
        configureGestureRecognizer()
        configureTableView()
        configureData()
        textView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        assignFrames()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        textView.becomeFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            self.tableView.scrollToRow(at: IndexPath(row: (self.data?.count ?? 0), section: 0), at: .top, animated: true)
        }
    }
    
    @objc func keyboardWillChangeFrame(_ notification: Notification?) { // emoji keyboard
        if let keyboardFrame: NSValue = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            UIView.animate(withDuration: TimeInterval((notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.floatValue ?? 0.0), delay: 0, options: UIView.AnimationOptions(rawValue: UInt((notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue ?? 0)), animations: {
    
                let keyboardHeight = keyboardRectangle.height
                self.view.frame.size.height = ((UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.height ?? 0) - keyboardHeight
                self.isExpand = true
            })
        }
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
    
    private func configureData() {
        let myUserId = StorageManager.shared.callUserInfo()!.id
        let userId = user!.id
        DatabaseManager.shared.readMessages(senderId: myUserId, recipientId: userId) { messages in
            DispatchQueue.main.async {
                self.layoutMessage(messages)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                self.tableView.scrollToRow(at: IndexPath(row: (self.data?.count ?? 0), section: 0), at: .top, animated: true)
            }
        }
    }
    
    private func layoutMessage(_ messages: [Message]) {
        var messageList = [Message]()
        
        for i in 0..<messages.count {
            if i == 0 {
                let newMessage = Message(id: 0, senderId: 0, recipientId: 0, content: "", dayString: String(messages[i].dayString.dropLast(9)).replacingOccurrences(of: "-", with: " "))
                messageList.append(newMessage)
                messageList.append(messages[i])
            } else {
                if String(messages[i].dayString.dropLast(9)) != String(messageList.last!.dayString.dropLast(9)) {
                    let newMessage = Message(id: 0, senderId: 0, recipientId: 0, content: "", dayString: String(messages[i].dayString.dropLast(9)).replacingOccurrences(of: "-", with: " "))
                    messageList.append(newMessage)
                    messageList.append(messages[i])
                } else {
                    messageList.append(messages[i])
                }
            }
        }
        self.data = messageList
        self.tableView.reloadData()
    }
    
    
    private func configureNaviBar() {
        let cell = configureCustomView()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cell)
        self.navigationItem.leftItemsSupplementBackButton = true
    }
    
    private func configureCustomView() -> PeopleTableViewCell {
        let username = user?.username
        let headerCell = PeopleTableViewCell()
        headerCell.index = 2
        headerCell.profileImageView.setProfileImage(username: username!)
        headerCell.configureUsername(username!)
        headerCell.frame.size.width = 230
        headerCell.frame.size.height = (self.navigationController?.navigationBar.frame.size.height ?? 0 - 5)/2
        return headerCell
    }
    
    private func addSubViews() {
        self.view.addSubview(topLine)
        self.view.addSubview(textBackgroundView)
        textBackgroundView.addSubview(textBox)
        textBox.addSubview(cameraButton)
        textBox.addSubview(galleryButton)
        textBox.addSubview(textView)
    }
    
    private func addTargets() {
        cameraButton.addTarget(self, action: #selector(didTapCameraButton), for: .touchUpInside)
        galleryButton.addTarget(self, action: #selector(didTapGalleryButton), for: .touchUpInside)
    }
    
    private func configureGestureRecognizer() {
        let tab = UITapGestureRecognizer(target: self, action: #selector(didTapSelf))
        view.addGestureRecognizer(tab)
    }
    
    private func configureTableView() {
        tableView.register(MessageHeaderTableViewCell.self, forCellReuseIdentifier: MessageHeaderTableViewCell.identifier)
        tableView.register(TheOtherMessageTableViewCell.self, forCellReuseIdentifier: TheOtherMessageTableViewCell.identifier)
        tableView.register(MyMessageTableViewCell.self, forCellReuseIdentifier: MyMessageTableViewCell.identifier)
        tableView.register(MyPhotoMessageTableViewCell.self, forCellReuseIdentifier: MyPhotoMessageTableViewCell.identifier)
        tableView.register(TheOtherPhotoMessageTableViewCell.self, forCellReuseIdentifier: TheOtherPhotoMessageTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
    }
    
    @objc func didTapSelf() {
        textView.resignFirstResponder()
    }
    
    @objc func didTapCameraButton() {
        print("camera")
    }
    
    @objc func didTapGalleryButton() {
        print("gallery")
    }
    
    private func assignFrames() {
        topLine.frame.origin.x = 0
        topLine.frame.origin.y = self.navigationController?.navigationBar.bottom ?? 0
        topLine.frame.size.width = self.view.width
        textBackgroundView.frame = CGRect(x: 0, y: view.height - 60, width: view.width, height: 60)
        textBox.frame = CGRect(x: 10, y: 5, width: view.width - 20, height: (textBackgroundView.height - 20))
        var size = textBox.height - 10
        cameraButton.frame = CGRect(x: 5, y: 5, width: size, height: size)
        size = textBox.height - 20
        galleryButton.frame = CGRect(x: textBox.width - 20 - size, y: 10, width: size, height: size)
        textView.frame = CGRect(x: cameraButton.right + 10, y: 10, width: textBox.width - cameraButton.right - 5 - 20 - size - 20, height: size)
        tableView.frame = CGRect(x: 0, y: topLine.bottom, width: view.width, height: view.height - 130)
    }
    
    private func sendMessage() {
        let message = textView.text ?? ""
        let myUserId = StorageManager.shared.callUserInfo()!.id
        let userId = user!.id
        let dayString = Date().description
        let entity = Message(id: 0, senderId: myUserId, recipientId: userId, content: message, dayString: dayString)
        DatabaseManager.shared.insertMessage(message: entity) { result in
            if result == Result.success.rawValue {
                DispatchQueue.main.async {
                    self.configureData()
                }
            } else {
                fatalError("Message insert fail")
            }
        }
    }
}

extension MessageViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray {
            textView.text = nil
            textView.textColor = .black
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            self.tableView.scrollToRow(at: IndexPath(row: (self.data?.count ?? 0), section: 0), at: .top, animated: true)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Message..."
            textView.textColor = .systemGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            sendMessage()
            textView.text = ""
            textViewDidEndEditing(textView)
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (data?.count ?? 0) + (1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MessageHeaderTableViewCell.identifier, for: indexPath) as! MessageHeaderTableViewCell
            cell.profileImage.setProfileImage(username: user!.username)
            cell.configureLabels(user!.name, user!.username, user!.id)
            return cell
        }
        
        guard let hasData = self.data else {
            return UITableViewCell()
        }
        
        let theOtherCell = tableView.dequeueReusableCell(withIdentifier: TheOtherMessageTableViewCell.identifier, for: indexPath) as! TheOtherMessageTableViewCell
        let myCell = tableView.dequeueReusableCell(withIdentifier: MyMessageTableViewCell.identifier, for: indexPath) as! MyMessageTableViewCell
        let timeCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let myPhotoCell = tableView.dequeueReusableCell(withIdentifier: MyPhotoMessageTableViewCell.identifier, for: indexPath) as! MyPhotoMessageTableViewCell
        let theOtherPhotoCell = tableView.dequeueReusableCell(withIdentifier: TheOtherPhotoMessageTableViewCell.identifier, for: indexPath) as! TheOtherPhotoMessageTableViewCell
        
        let myUserId = StorageManager.shared.callUserInfo()!.id
        let userId = user!.id
        let message = hasData[indexPath.row - 1]
        let content = message.content
        let dayString = message.dayString
        let time = String(dayString.split(separator: " ", omittingEmptySubsequences: true).last!.dropLast(3))
        
        if message.id == 0 {
            timeCell.textLabel?.text = message.dayString
            timeCell.textLabel?.textAlignment = .center
            timeCell.textLabel?.textColor = .black.withAlphaComponent(0.7)
            timeCell.textLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
            return timeCell
        }
        
        if message.senderId == myUserId {
            if message.postId == 0 {
                myCell.configureCell(content, time)
                return myCell
            } else {
                myPhotoCell.configureCell(content, time, message.postId)
                myPhotoCell.delegate = self
                return myPhotoCell
            }
        } else if message.senderId == userId {
            if message.postId == 0 {
                theOtherCell.configureCell(user!, content, time)
                return theOtherCell
            } else {
                theOtherPhotoCell.configureCell(user!, content, time, message.postId)
                theOtherPhotoCell.delegate = self
                return theOtherPhotoCell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

extension MessageViewController: TheOtherPhotoMessageTableViewCellDelegate {
    func didTapPostLink(_ post: Post) {
        textView.resignFirstResponder()
        let postListVC = PostListViewController()
        postListVC.posts = [post]
        postListVC.titleText = "Post"
        self.navigationController?.pushViewController(postListVC, animated: true)
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .black
    }
}

extension MessageViewController: MyPhotoMessageTableViewCellDelegate {
    func didTapMyPostLink(_ post: Post) {
        textView.resignFirstResponder()
        let postListVC = PostListViewController()
        postListVC.posts = [post]
        postListVC.titleText = "Post"
        self.navigationController?.pushViewController(postListVC, animated: true)
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .black
    }
}


