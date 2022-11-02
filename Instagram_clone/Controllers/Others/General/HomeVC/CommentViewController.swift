
import UIKit

class CommentViewController: UIViewController {
    
    private lazy var mentionHashTagSearchView = CommentMentionHashTagSearchView()
    lazy var mentions = [String]()
    lazy var hashTags = [String]()
    
    var postId: Int?
    
    var data: [Comment]?
    
    private var isExpand = false
    
    private var tableView = UITableView()
    
    private let bottomView: UIView = {
       let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let innerView: UIView = {
       let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    public let postButton: UIButton = {
       let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.systemGray.withAlphaComponent(0.5), for: .normal)
        button.isEnabled = false
        return button
    }()
    
    public let textView: UITextView = {
       let textView = UITextView()
        textView.enablesReturnKeyAutomatically = true
        textView.font = .systemFont(ofSize: 17)
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.tabBarController?.tabBar.isHidden = true
        
        configureTableView()
        addSubViews()
        
        configureImageView()
        postButton.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
        textView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        touchView()
        configureData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        assignFrames()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
    
    private func touchView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(eliminateKeyboard))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        tableView.addGestureRecognizer(gesture)
    }
    
    @objc func eliminateKeyboard() {
        textView.resignFirstResponder()
        self.mentionHashTagSearchView.isHidden = true
    }
    
    private func configureTableView() {
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.alwaysBounceVertical = false
        self.view.addSubview(tableView)
    }
    
    public func configureData() {
        guard let hasPostId = self.postId else {
            return
        }
        
        DatabaseManager.shared.readAllComments(postId: hasPostId) { comments in
            self.data = comments
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    public func addSubViews() {
        self.view.addSubview(bottomView)
        self.view.addSubview(mentionHashTagSearchView)
        bottomView.addSubview(imageView)
        bottomView.addSubview(innerView)
        innerView.addSubview(postButton)
        innerView.addSubview(textView)
    }
    
    private func configureImageView() {
        let username = StorageManager.shared.callUserInfo()!.username
        imageView.setProfileImage(username: username)
    }
    
    public func assignFrames() {
        bottomView.frame.size.height = 60
        
        if mentionHashTagSearchView.isHidden {
            tableView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height - bottomView.frame.size.height)
        } else {
            tableView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height - bottomView.frame.size.height - 30)
        }
    
        bottomView.frame = CGRect(x: 0, y: self.view.height - bottomView.frame.size.height, width: self.view.width, height: bottomView.frame.size.height)
        mentionHashTagSearchView.frame = CGRect(x: 0, y: bottomView.top - 30, width: self.view.width, height: 30)
        
        let imageViewSize: CGFloat = 45
        imageView.frame = CGRect(x: 20, y: (bottomView.frame.size.height - imageViewSize) / 2, width: imageViewSize, height: imageViewSize)
        imageView.layer.cornerRadius = imageViewSize / 2
        
        innerView.frame = CGRect(x: imageView.right + 20, y: (bottomView.height - 45) / 2, width: self.view.width - imageView.right - 20 - 20, height: 45)
        innerView.layer.cornerRadius = 20
        
        let postButtonWidth: CGFloat = 80
        postButton.frame = CGRect(x: innerView.width - postButtonWidth + 10, y: (innerView.height - postButtonWidth/2) / 2, width: postButtonWidth, height: postButtonWidth / 2)
        
        textView.frame = CGRect(x: 10, y: 10, width: innerView.width - postButtonWidth + 10, height: innerView.height - 20)
    }
    
    private func makePostButtonEnable() {
        postButton.setTitleColor(.systemBlue, for: .normal)
        postButton.isEnabled = true
    }
    
    private func makePostButtonDisenable() {
        postButton.setTitleColor(.systemGray.withAlphaComponent(0.5), for: .normal)
        postButton.isEnabled = false
    }
    
    @objc public func didTapPostButton() {
        let content = textView.text!
        let username = StorageManager.shared.callUserInfo()!.username
        let likes = [String]()
        let dayString = Date().description
        let postId = self.postId!
        
        let comment = Comment(id: 0, content: content, username: username, likes: likes, mentions: self.mentions, hashtags: self.hashTags, dayString: dayString, postId: postId)
        
        DatabaseManager.shared.insertComment(comment: comment) { result in
            switch result {
            case Result.success.rawValue:
                DispatchQueue.main.async {
                    self.textView.text = ""
                    self.makePostButtonDisenable()
                }
                self.configureData()
            case Result.failure.rawValue:
                print("Fail")
            default:
                fatalError("Invalid value")
            }
        }
    }
    
    public func disappearKeyboard() {
        textView.resignFirstResponder()
    }
    
    private func setMentionHashTagTextColor(_ mainText: String) {
        let hashTagSubString = mainText.split(separator: "#", maxSplits: 1, omittingEmptySubsequences: false).last
        let hashTagString = "#" + String(hashTagSubString ?? "")
        let rangeForHashtag = (mainText as NSString).range(of: hashTagString)
        
        let mentionSubString = mainText.split(separator: "@", maxSplits: 1, omittingEmptySubsequences: false).last
        let mentionString = "@" + String(mentionSubString ?? "")
        let blueColorString = String(mentionString.split(separator: "#", maxSplits: 1, omittingEmptySubsequences: false).first ?? "")
        let rangeForMention = (mainText as NSString).range(of: blueColorString)

        let mutableAttributedString = NSMutableAttributedString.init(string: mainText)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemGray, range: rangeForHashtag)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: rangeForMention)
        textView.attributedText = mutableAttributedString
    }
    
    private func searchMention(_ keyword: String) {
        self.mentionHashTagSearchView.index = 0
        guard !keyword.isEmpty else {
            hideMentionHashtagSearchView()
            return
        }
        DatabaseManager.shared.searchUsers(username: keyword) { users in
            DispatchQueue.main.async {
                if users.count > 0 {
                    self.showMentionHashtagSearchView()
                    self.mentionHashTagSearchView.data = users.map( { $0.0} )
                    self.mentionHashTagSearchView.delegate = self
                    self.mentionHashTagSearchView.reloadCollectionView()
                } else {
                    self.hideMentionHashtagSearchView()
                }
            }
        }
    }
    
    private func searchHashTag(_ keyword: String) {
        self.mentionHashTagSearchView.index = 1
        guard !keyword.isEmpty else {
            hideMentionHashtagSearchView()
            return
        }
        
        DatabaseManager.shared.searchHashTag(keyword) { hashTags in
            if hashTags.count > 0 {
                var hashTagNameList = [String]()
                for hashTag in hashTags {
                    hashTagNameList.append(hashTag.name)
                }
                
                DispatchQueue.main.async {
                    self.showMentionHashtagSearchView()
                    self.mentionHashTagSearchView.data = hashTagNameList
                    self.mentionHashTagSearchView.delegate = self
                    self.mentionHashTagSearchView.reloadCollectionView()
                }
                
            } else {
                DispatchQueue.main.async {
                    self.hideMentionHashtagSearchView()
                }
            }
        }
    }
    
    private func checkMentionHashtagDataAndRemoveIfNeeded(_ text: String) {
        for i in 0..<mentions.count {
            let username = mentions[i]
            if !text.contains("@" + username) {
                mentions.remove(at: i)
            }
        }
        
        for i in 0..<hashTags.count {
            let hashTagName = hashTags[i]
            if !text.contains("#" + hashTagName) {
                hashTags.remove(at: i)
            }
        }
    }
    
    private func showMentionHashtagSearchView() {
        mentionHashTagSearchView.isHidden = false
        viewDidLayoutSubviews()
    }
    
    private func hideMentionHashtagSearchView() {
        mentionHashTagSearchView.isHidden = true
        viewDidLayoutSubviews()
    }
    
    
}

extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as! CommentTableViewCell
        guard let hasData = self.data else {
            return cell
        }
        let comment = hasData[indexPath.row]
        
        cell.setValues(username: comment.username, content: comment.content, dayString: comment.dayString, likes: comment.likes)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension CommentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespaces).count > 0 {
            makePostButtonEnable()
        } else {
            makePostButtonDisenable()
        }
        
        setMentionHashTagTextColor(textView.text)
        checkMentionHashtagDataAndRemoveIfNeeded(textView.text)
        
        if textView.text.contains("#") {
            var word = textView.text.components(separatedBy: "#").last!
            if word.contains("\n") || word.contains("@") {
                hideMentionHashtagSearchView()
                return
            }
            word = word.trimmingCharacters(in: .whitespaces)
            self.searchHashTag(word)
        }
        
        
        if textView.text.contains("@") {
            var word = textView.text.components(separatedBy: "@").last!
            if word.contains("\n") || word.contains("#") {
                hideMentionHashtagSearchView()
                return
            }
            word = word.trimmingCharacters(in: .whitespaces)
            self.searchMention(word)
        }
        
        
    }
}

extension CommentViewController: CommentTableViewCellDelegate {
    func didTapCommentLikeButton(sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexpath = tableView.indexPathForRow(at: point) else {
            return
        }
        guard let hasData = self.data else {
            return
        }
        let commentId = hasData[indexpath.row].id
        let username = StorageManager.shared.callUserInfo()!.username
        
        if sender.imageView?.image == UIImage(systemName: "heart") {
            DatabaseManager.shared.insertLike(commentId: commentId, username: username) { comment in
                if comment.id == commentId {
                    DispatchQueue.main.async {
                        self.data![indexpath.row] = comment
                        self.tableView.beginUpdates()
                        (self.tableView.cellForRow(at: indexpath) as! CommentTableViewCell).setValues(username: comment.username, content: comment.content, dayString: comment.dayString, likes: comment.likes)
                        (self.tableView.cellForRow(at: indexpath) as! CommentTableViewCell).changeLikeButtonToFill()
                        self.tableView.endUpdates()
                    }
                }
            }
        } else if sender.imageView?.image == UIImage(systemName: "heart.fill") {
            DatabaseManager.shared.deleteLike(commentId: commentId, username: username) { comment in
                if comment.id == commentId {
                    DispatchQueue.main.async {
                        self.data![indexpath.row] = comment
                        self.tableView.beginUpdates()
                        (self.tableView.cellForRow(at: indexpath) as! CommentTableViewCell).setValues(username: comment.username, content: comment.content, dayString: comment.dayString, likes: comment.likes)
                        (self.tableView.cellForRow(at: indexpath) as! CommentTableViewCell).changeLikeButtonToEmpty()
                        self.tableView.endUpdates()
                    }
                }
            }
        }
    }
    
    
}

extension CommentViewController: CommentMentionHashTagSearchViewDelegate {
    func selectCell(_ index: Int, _ text: String) {
        if index == 0 {
            let content = self.textView.text ?? ""
            let reversedContent = String(content.reversed())
            let splittedReversedContent = reversedContent.split(separator: "@", maxSplits: 1, omittingEmptySubsequences: false)
            var mainContent = String((splittedReversedContent.last ?? "").reversed())
            let tail = "@\(text)"
            
            for username in mentions {
                if text == username {
                    setMentionHashTagTextColor(mainContent)
                    self.mentionHashTagSearchView.data?.removeAll()
                    self.mentionHashTagSearchView.reloadCollectionView()
                    hideMentionHashtagSearchView()
                    return
                }
            }
            mentions.append(text)
            
            mainContent += tail
            setMentionHashTagTextColor(mainContent)
            
            self.mentionHashTagSearchView.data?.removeAll()
            self.mentionHashTagSearchView.reloadCollectionView()
            hideMentionHashtagSearchView()
        } else if index == 1 {
            let content = self.textView.text ?? ""
            let reversedContent = String(content.reversed())
            let splittedReversedContent = reversedContent.split(separator: "#", maxSplits: 1, omittingEmptySubsequences: false)
            var mainContent = String((splittedReversedContent.last ?? "").reversed())
            let tail = "#\(text)"
            
            
            for hashTag in hashTags {
                if text == hashTag {
                    setMentionHashTagTextColor(mainContent)
                    self.mentionHashTagSearchView.data?.removeAll()
                    self.mentionHashTagSearchView.reloadCollectionView()
                    hideMentionHashtagSearchView()
                    return
                }
            }
            hashTags.append(text)
            
            mainContent += tail
            setMentionHashTagTextColor(mainContent)
            
            self.mentionHashTagSearchView.data?.removeAll()
            self.mentionHashTagSearchView.reloadCollectionView()
            hideMentionHashtagSearchView()
        }
    }
    
    
}
    


