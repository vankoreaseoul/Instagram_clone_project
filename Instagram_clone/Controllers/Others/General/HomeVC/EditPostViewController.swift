import UIKit
import GooglePlaces

protocol EditPostViewControllerDelegate {
    func didTapDoneButton(_ indexpathRow: Int, _ post: Post)
}

class EditPostViewController: UIViewController {
    
    var delegate: EditPostViewControllerDelegate?
    
    var posts: [Post]?
    var indexpathRow = 0
    private var isExpand = false
    
    private lazy var mentionHashTagSearchView = CommentMentionHashTagSearchView()
    lazy var mentions = [String]()
    lazy var hashTags = [String]()
    
    let naviBarBottomLine: UIView = {
       let view = UIView()
        view.backgroundColor = .systemGray.withAlphaComponent(0.3)
        return view
    }()
    
    let cell = PostHeaderTableViewCell()
    
    private let tableView = UITableView()
    
    private let tagIconButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "mentionIcon"), for: .normal)
        button.tintColor = .black
        button.frame.size = CGSize(width: 30, height: 30)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let textView: UITextView = {
       let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 17)
        textView.textAlignment = .left
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNaviBar()
        configureCell()
        view.addSubview(naviBarBottomLine)
        view.addSubview(mentionHashTagSearchView)
        configureTableView()
        configureMentionAndHashtag()
        textView.becomeFirstResponder()
        
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
    }
    
    @objc func keyboardWillChangeFrame(_ notification: Notification?) {
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
            self.mentionHashTagSearchView.isHidden = true
        }
    }
    
    @objc func eliminateKeyboard() {
        textView.resignFirstResponder()
        keyboardDisappear()
    }
    
    private func configureNaviBar() {
        self.navigationItem.title = "Edit Info"
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancelButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTapDoneButton))
    }
    
    private func configureCell() {
        guard let hasPost = posts else {
            return
        }
        let username = hasPost.first!.username
        var location = hasPost.first!.location
        if location.isEmpty {
            location = "Add Location..."
        }
        
        cell.profileImage.setProfileImage(username: username)
        cell.setUsernameAndLocation(username: username, location: location)
        cell.usernameLabel.textColor = .systemGray
        cell.locationLabel.setTitleColor(.black, for: .normal)
        cell.addAction()
        self.view.addSubview(cell)
        cell.delegate = self
    }
    
    private func configureTableView() {
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureMentionAndHashtag() {
        let post = posts!.first!
        if !post.mentions.isEmpty {
            self.mentions = post.mentions
        }
        if !post.hashtags.isEmpty {
            self.hashTags = post.hashtags
        }
    }
    
    private func assignFrames() {
        let statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        naviBarBottomLine.frame = CGRect(x: 0, y: statusHeight + navigationBarHeight, width: view.width, height: 1)
        cell.frame = CGRect(x: 0, y: naviBarBottomLine.bottom, width: view.width, height: 50)
        
        if mentionHashTagSearchView.isHidden {
            tableView.frame = CGRect(x: 0, y: cell.bottom, width: view.width, height: view.height - cell.bottom)
        } else {
            tableView.frame = CGRect(x: 0, y: cell.bottom, width: view.width, height: view.height - cell.bottom - 30)
        }
        
        mentionHashTagSearchView.frame = CGRect(x: 0, y: view.height - 30, width: self.view.width, height: 30)
    }
  
    @objc func didTapCancelButton() {
        self.dismiss(animated: false)
    }
    
    @objc func didTapDoneButton() {
        let content = self.textView.text
        let mentions = self.mentions
        let hashtags = self.hashTags
        var location = ""
        if cell.locationLabel.title(for: .normal) != "Add Location..." {
            location = cell.locationLabel.title(for: .normal)!
        }
        let dayString = Date().description
        var post = posts!.first!
        post.content = content ?? ""
        post.mentions = mentions
        post.hashtags = hashtags
        post.location = location
        post.dayString = dayString
        DatabaseManager.shared.updatePost(post: post) { post in
            if post.id != 0 {
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                    self.delegate?.didTapDoneButton(self.indexpathRow, post)
                }
            }
        }
    }

    func showAddLocationPage() {
      let autocompleteVC = GMSAutocompleteViewController()
        autocompleteVC.delegate = self

      // Specify the place data types to return.
      let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
        UInt(GMSPlaceField.placeID.rawValue))
        autocompleteVC.placeFields = fields

      // Specify a filter.
      let filter = GMSAutocompleteFilter()
      filter.types = [kGMSPlaceTypeCollectionAddress]
        autocompleteVC.autocompleteFilter = filter

      // Display the autocomplete view controller.
        autocompleteVC.primaryTextHighlightColor = .black
        autocompleteVC.tableCellBackgroundColor = .systemBackground
        autocompleteVC.tableCellSeparatorColor = .systemGray.withAlphaComponent(0.3)
        let autocompleteNC = UINavigationController(rootViewController: autocompleteVC)
        autocompleteNC.navigationBar.tintColor = .black
        autocompleteNC.modalPresentationStyle = .fullScreen
        self.present(autocompleteNC, animated: true)
    }
}

extension EditPostViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let location = place.name
        
        if let hasLocation = location {
            cell.locationLabel.setTitle(hasLocation, for: .normal)
            cell.locationLabel.sizeToFit()
        }
      
      dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension EditPostViewController: PostHeaderTableViewCellDelegate {
    func didTapMoreButton(_ sender: UIButton) {
        return
    }
    
    func didTapLocationButton() {
        showAddLocationPage()
    }
}

extension EditPostViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (posts?.count ?? 0) * 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let hasPost = posts else {
            return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        }
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
            cell.mainImageView.setPostImage(username: hasPost.first!.username, postId: hasPost.first!.id)
            cell.configureTagButton()
            cell.delegate = self
            let gesture = UITapGestureRecognizer(target: self, action: #selector(eliminateKeyboard))
            gesture.numberOfTapsRequired = 1
            gesture.numberOfTouchesRequired = 1
            cell.addGestureRecognizer(gesture)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            setMentionHashTagTextColor(hasPost.first!.content)
            let newSize = textView.sizeThatFits(CGSize(width: view.width, height: view.height))
            textView.frame.size = CGSize(width: view.width, height: newSize.height)
            cell.addSubview(textView)
            textView.delegate = self
            textView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            let bottomConstraint = textView.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
            bottomConstraint.priority = .defaultHigh
            bottomConstraint.isActive = true
            cell.contentView.isUserInteractionEnabled = false
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return view.width
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            textView.becomeFirstResponder()
        }
    }
}

extension EditPostViewController: PostTableViewCellDelegate {
    func didTapTagButton() {
        guard let hasPost = posts else {
            return
        }
        let tagPeople = hasPost.first!.tagPeople
        let tagPeopleVC = TagPeopleViewController()
        var list = [(String, String)]()
        for username in tagPeople {
            list.append((username, ""))
        }
        tagPeopleVC.data = list
        tagPeopleVC.imageView.setPostImage(username: hasPost.first!.username, postId: hasPost.first!.id)
        tagPeopleVC.delegate = self
        
        let tagPeopleNC = UINavigationController(rootViewController: tagPeopleVC)
        tagPeopleNC.modalPresentationStyle = .fullScreen
        self.present(tagPeopleNC, animated: false)
    }
    
}

extension EditPostViewController: TagPeopleViewControllerDelegate {
    func bringTagPeople(_ data: [(String, String)]) {
        var usernames = [String]()
        for element in data {
            usernames.append(element.0)
        }
        var post = posts!.first!
        post.tagPeople = usernames
        posts!.removeAll()
        posts!.append(post)
    }
}

extension EditPostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let newSize = textView.sizeThatFits(CGSize(width: view.width, height: view.height))
        
        if newSize.height != self.textView.frame.size.height {
            self.textView.frame.size.height = newSize.height
            if let cell = textView.superview as? UITableViewCell {
                self.tableView.beginUpdates()
                cell.sizeToFit()
                self.tableView.endUpdates()
            }
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
    
    private func setMentionHashTagTextColor(_ mainText: String) {
        let hashTagSubString = mainText.split(separator: "#", maxSplits: 1, omittingEmptySubsequences: false).last
        let hashTagString = "#" + String(hashTagSubString ?? "")
        let rangeForHashtag = (mainText as NSString).range(of: hashTagString)
        
        let mentionSubString = mainText.split(separator: "@", maxSplits: 1, omittingEmptySubsequences: false).last
        let mentionString = "@" + String(mentionSubString ?? "")
        let blueColorString = String(mentionString.split(separator: "#", maxSplits: 1, omittingEmptySubsequences: false).first ?? "")
        let rangeForMention = (mainText as NSString).range(of: blueColorString)

        let mutableAttributedString = NSMutableAttributedString.init(string: mainText)
        let totalRange = (mainText as NSString).range(of: mainText)
        
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemGray, range: rangeForHashtag)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: rangeForMention)
        mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 17), range:totalRange)
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
        let indexPath = NSIndexPath(row: 1, section: 0)
        self.tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
    }
    
    private func hideMentionHashtagSearchView() {
        mentionHashTagSearchView.isHidden = true
        viewDidLayoutSubviews()
    }
    
}

extension EditPostViewController: CommentMentionHashTagSearchViewDelegate {
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
