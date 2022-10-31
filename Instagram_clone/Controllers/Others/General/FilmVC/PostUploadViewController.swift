
import UIKit
import GooglePlaces

class PostUploadViewController: UIViewController {
    
    private lazy var alert = InputAlertView()
    
    struct model {
        let title: String
        let handler: () -> Void
    }
    
    private let searchResultView: MentionHashTagSearchResultView = {
       let view = MentionHashTagSearchResultView()
        view.backgroundColor = .systemBackground
        view.isHidden = true
        return view
    }()
    
    private var locationView: UIView?
    
    private var location: String?
    
    private var tagPeople: [(String, String)]?
    
    private var mentionUsers: [String]? // username
    
    private var hashTags: [String]?
    
    private var modelList = [model]()
    
    private var textViewMaxHeight: CGFloat?
    
    var image: UIImage?
    
    private var dummyView =  UIView()
    
    private let captionView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let captionViewLine: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray.withAlphaComponent(0.3)
        return line
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let textView: UITextView = {
       let textView = UITextView()
        textView.text = "Write a caption...\n@\n#"
        textView.textColor = .lightGray
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var tagPeopleMark: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .systemBackground
        configureNaviBar()
        addSubviews()
        configureModelList()
        
        textView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardAppear(_ notification: Notification) {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                
                self.dummyView.frame.size.height = view.height - keyboardHeight - self.captionView.height
                self.searchResultView.frame.size.height = self.dummyView.frame.size.height
            }
    }
    
    @objc func keyboardDisappear() {
        self.dummyView.frame.size.height = view.height - self.captionView.height
        self.searchResultView.frame.size.height = self.dummyView.frame.size.height
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        assignFrames()
    }
    
    private func configureNaviBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(didTapShareButton))
    }
    
    private func configureModelList() {
        modelList.append(
            model(title: "Tag People", handler: { [weak self] in
                let tagPeopleVC = TagPeopleViewController()
                tagPeopleVC.title = "Tag People"
                tagPeopleVC.image = self?.image
                tagPeopleVC.delegate = self
                if let hasTagPeople = self?.tagPeople {
                    tagPeopleVC.data = hasTagPeople
                }
                
                let tagPeopleNC = UINavigationController(rootViewController: tagPeopleVC)
                tagPeopleNC.modalPresentationStyle = .fullScreen
                self?.present(tagPeopleNC, animated: true)
            })
        )
        modelList.append(
            model(title: "Add Location") { [weak self] in
                self?.showAddLocationPage()
            }
        )
    }
    
    @objc func didTapShareButton() {
        let image = self.imageView.image!
        let username = (StorageManager.shared.callUserInfo()!).username
        var content = textView.text ?? ""
        if textView.text == "Write a caption...\n@\n#" {
            content = ""
        }
        let tagPeopleUsernameList = tagPeople?.map( {$0.0} ) ?? []
        let location = self.location ?? ""
        let day = Date()
        
        let mentions = self.mentionUsers ?? []
        let hashTags = self.hashTags ?? []
        let likes = [String]()
        
        let post = Post(id: 0, username: username, content: content, mentions: mentions, hashtags: hashTags, tagPeople: tagPeopleUsernameList, location: location, dayString: day.description, likes: likes)
        DatabaseManager.shared.inserPost(post: post) { result in
            if result == "0" {
                fatalError("Server Problem")
            } else {
                let postImageTitle = result
                StorageManager.shared.uploadImage(paramName: "file", fileName: postImageTitle, image: image)
                DispatchQueue.main.async {
                    (self.view.window?.rootViewController as? UITabBarController)?.selectedIndex = 0
                    self.view.window?.rootViewController?.dismiss(animated: true)
                }
            }
        }
        
    }
    
    private func addSubviews() {
        self.view.addSubview(captionView)
        self.view.addSubview(imageView)
        self.view.addSubview(textView)
        self.view.addSubview(captionViewLine)
        self.view.addSubview(tableView)
        
        if let hasImage = image {
            imageView.image = hasImage
        }
    }
    
    private func assignFrames() {
        let statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let naviBarHeight = self.navigationController?.navigationBar.height ?? 0
        
        let size = self.view.width * 0.2
        imageView.frame = CGRect(x: 15, y: statusHeight + naviBarHeight + 20, width: size, height: size)
        textView.frame.origin.x = imageView.right + 10
        textView.frame.origin.y = imageView.top - 10
        textView.frame.size.width = self.view.width - 30 - 10 - imageView.width
        textViewMaxHeight = size + 50
        NSLayoutConstraint.activate([textView.heightAnchor.constraint(lessThanOrEqualToConstant: textViewMaxHeight!), textView.heightAnchor.constraint(greaterThanOrEqualToConstant: size)])
        
        captionView.frame.origin.x = 0
        captionView.frame.origin.y = statusHeight + naviBarHeight
        captionView.frame.size.width = self.view.width

        if textView.contentSize.height < size {
            captionView.frame.size.height = self.view.height * 0.18
        } else if textView.contentSize.height <= textViewMaxHeight! {
            captionView.frame.size.height = textView.contentSize.height + 40
            dummyView.frame.origin.y = captionView.bottom
        } else {
            captionView.frame.size.height = textView.height + 40
            dummyView.frame.origin.y = captionView.bottom
        }
        makeLine()
        
        tableView.frame = CGRect(x: 0, y: captionView.bottom + 1, width: self.view.width, height: self.view.height - captionView.height)
    }
    
    private func makeLine() {
        captionViewLine.frame = .zero
        captionViewLine.frame = CGRect(x: 0, y: captionView.bottom, width: view.width, height: 1)
    }
    
    private func setFocusEffect() {
        self.view.addSubview(dummyView)
        dummyView.backgroundColor = .lightGray.withAlphaComponent(0.5)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCaptionOKButton))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        gesture.delegate = self
        dummyView.addGestureRecognizer(gesture)
        
        dummyView.frame = CGRect(x: 0, y: self.view.height, width: self.view.width, height: 0)
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.dummyView.frame = CGRect(x: 0, y: self.captionViewLine.bottom, width: self.view.width, height: self.view.height - self.captionViewLine.bottom)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(didTapCaptionOKButton))
        self.title = "Caption"
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.dummyView.addSubview(searchResultView)
        self.searchResultView.frame = dummyView.bounds
    }
    
    @objc private func didTapCaptionOKButton() {
        self.navigationItem.setHidesBackButton(false, animated: false)
        self.title = "New Post"
        self.configureNaviBar()
        searchResultView.removeFromSuperview()
        dummyView.removeFromSuperview()
        textView.resignFirstResponder()
        self.textView.sizeToFit()
    }
    
    private func searchMention(_ keyword: String) {
        self.searchResultView.index = 0
        guard !keyword.isEmpty else {
            self.searchResultView.isHidden = true
            return
        }
        DatabaseManager.shared.searchUsers(username: keyword) { users in
            DispatchQueue.main.async {
                self.searchResultView.isHidden = false
                self.searchResultView.data = users
                self.searchResultView.delegate = self
                self.searchResultView.reloadTableView()
            }
        }
    }
    
    private func searchHashTag(_ keyword: String) {
        self.searchResultView.index = 1
        guard !keyword.isEmpty else {
            self.searchResultView.isHidden = true
            return
        }
        
        DatabaseManager.shared.searchHashTag(keyword) { hashTags in
            var hashTagList = [(String, String)]()
            for hashTag in hashTags {
                hashTagList.append((hashTag.name, ""))
            }
            
            DispatchQueue.main.async {
                self.searchResultView.isHidden = false
                self.searchResultView.data = hashTagList
                self.searchResultView.delegate = self
                self.searchResultView.reloadTableView()
            }
            
        }
    }
    
    private func putMarkOnCell(_ text: String) {
        tagPeopleMark = UILabel()
        tagPeopleMark?.text = text
        tagPeopleMark?.textAlignment = .right
        tagPeopleMark?.textColor = .lightGray
        let tagPeopleCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        tagPeopleCell?.addSubview(tagPeopleMark!)
        tagPeopleMark?.frame = CGRect(x: 130, y: (tagPeopleCell!.height - 20) / 2, width: tagPeopleCell!.width - 170, height: 20)
    }
    
    private func removeMarkOnCell() {
        guard let hasMark = tagPeopleMark else {
            return
        }
        hasMark.removeFromSuperview()
    }
    
    private func configureLocationView(_ text: String) {
        locationView = UIView()
        locationView?.backgroundColor = .systemBackground
        let imageView = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
        let label = UILabel()
        label.text = text
        label.font = label.font.withSize(15)
        label.textColor = .systemBlue
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .systemGray.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        
        locationView?.addSubview(imageView)
        locationView?.addSubview(label)
        locationView?.addSubview(button)
        
        let addLocationCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0))
        addLocationCell?.addSubview(locationView!)
        locationView?.frame = CGRect(x: 0, y: 0, width: addLocationCell!.width, height: addLocationCell!.height - 1)
        imageView.frame = CGRect(x: 20, y: (locationView!.height - 30) / 2, width: 30, height: 30)
        label.frame = CGRect(x: imageView.right + 15, y: imageView.top, width: 250, height: 30)
        button.frame = CGRect(x: locationView!.width - 30, y: (locationView!.height - 15) / 2, width: 15, height: 15)
        tableView.reloadData()
    }
    
    @objc func didTapCloseButton() {
        locationView?.removeFromSuperview()
        locationView = nil
        self.location = nil
    }
    
    // MARK: - Google Place API
    
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
    
    private func checkMentionHashtagDataAndRemoveIfNeeded(_ text: String) {
        if let hasMentionUsers = self.mentionUsers {
            for i in 0..<hasMentionUsers.count {
                let username = hasMentionUsers[i]
                if !text.contains("@" + username) {
                    self.mentionUsers?.remove(at: i)
                }
            }
        }
    
        if let hasHashTags = self.hashTags {
            for i in 0..<hasHashTags.count {
                let hashTagName = hasHashTags[i]
                if !text.contains("#" + hashTagName) {
                    self.hashTags?.remove(at: i)
                }
            }
        }
    }
    

}

extension PostUploadViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == .lightGray {
                textView.text = nil
                textView.textColor = .black
            }
            setFocusEffect()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write a caption...\n@\n#"
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        setMentionHashTagTextColor(textView.text)
        checkMentionHashtagDataAndRemoveIfNeeded(textView.text)
        
        if textView.text.contains("#") {
            var word = textView.text.components(separatedBy: "#").last!
            if word.contains("\n") || word.contains("@") {
                self.searchResultView.isHidden = true
                return
            }
            word = word.trimmingCharacters(in: .whitespaces)
            self.searchHashTag(word)
        }
        
        
        if textView.text.contains("@") {
            var word = textView.text.components(separatedBy: "@").last!
            if word.contains("\n") || word.contains("#") {
                self.searchResultView.isHidden = true
                return
            }
            word = word.trimmingCharacters(in: .whitespaces)
            self.searchMention(word)
        }
    
        if textView.contentSize.height >= textViewMaxHeight! {
            self.textView.isScrollEnabled = true
        } else {
            self.textView.isScrollEnabled = false
            let size = CGSize(width: textView.width, height: textView.contentSize.height)
            self.textView.frame.size = self.textView.sizeThatFits(size)
        }
        
    }
    
}

extension PostUploadViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemBackground.withAlphaComponent(0.1)
        cell.textLabel?.text = modelList[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 && locationView != nil {
            return
        }
        modelList[indexPath.row].handler()
    }
}

extension PostUploadViewController: TagPeopleViewControllerDelegate {
    func bringTagPeople(_ data: [(String, String)]) {
        tagPeople = data
        
        let usernameList = data.map( {$0.0} )
        let quantity = usernameList.count
        
        if quantity == 0 {
            removeMarkOnCell()
        } else if quantity == 1 {
            removeMarkOnCell()
            putMarkOnCell(usernameList.first!)
        } else if quantity > 1 {
            let text = "\(quantity) People"
            removeMarkOnCell()
            putMarkOnCell(text)
        }
    }
    
    
}

extension PostUploadViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let location = place.name
        
        if let hasLocation = location {
            configureLocationView(hasLocation)
            self.location = hasLocation
        }
      
      dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
      // TODO: handle the error.
      print("Error: ", error.localizedDescription)
    }

    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
      dismiss(animated: true, completion: nil)
    }
}

extension PostUploadViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}

extension PostUploadViewController: MentionHashTagSearchResultViewDelegate {
    func didSelectHashTagCell(_ hashTag: HashTag) {
        let hashTagName = hashTag.name
        DispatchQueue.main.async {
            let content = self.textView.text ?? ""
            let reversedContent = String(content.reversed())
            let splittedReversedContent = reversedContent.split(separator: "#", maxSplits: 1, omittingEmptySubsequences: false)
            var mainContent = String((splittedReversedContent.last ?? "").reversed())
            let tail = "#\(hashTagName)"
            
            if self.hashTags != nil {
                for hashTag in self.hashTags! {
                    if hashTag == hashTagName {
                        self.setMentionHashTagTextColor(mainContent)
                        self.searchResultView.data?.removeAll()
                        self.searchResultView.reloadTableView()
                        self.searchResultView.isHidden = true
                        return
                    }
                }
                self.hashTags!.append(hashTagName)
            } else {
                self.hashTags = [String]()
                self.hashTags?.append(hashTagName)
            }
            
            mainContent += tail
            self.setMentionHashTagTextColor(mainContent)
            
            self.searchResultView.data?.removeAll()
            self.searchResultView.reloadTableView()
            self.searchResultView.isHidden = true
        }
    }
    
    
    func didTapEnrollHashTagButton() {
        let frame = self.view.bounds
        alert.assignFrame(frame)
        alert.configureAlert(message: "Create new Hashtag!", placeholder: "New Hashtag")
        self.navigationController?.view.addSubview(alert)
        alert.delegate = self
        alert.focusOnTextField()
    }
    
    func didSelectUserCell(_ user: User) {
        let username = user.username
        DispatchQueue.main.async {
            let content = self.textView.text ?? ""
            let reversedContent = String(content.reversed())
            let splittedReversedContent = reversedContent.split(separator: "@", maxSplits: 1, omittingEmptySubsequences: false)
            var mainContent = String((splittedReversedContent.last ?? "").reversed())
            let tail = "@\(username)"
            
            if self.mentionUsers != nil {
                for mentionedUsername in self.mentionUsers! {
                    if mentionedUsername == username {
                        self.setMentionHashTagTextColor(mainContent)
                        self.searchResultView.data?.removeAll()
                        self.searchResultView.reloadTableView()
                        self.searchResultView.isHidden = true
                        return
                    }
                }
                self.mentionUsers!.append(username)
            } else {
                self.mentionUsers = [String]()
                self.mentionUsers?.append(username)
            }
            
            mainContent += tail
            self.setMentionHashTagTextColor(mainContent)
            
            self.searchResultView.data?.removeAll()
            self.searchResultView.reloadTableView()
            self.searchResultView.isHidden = true
        }
    }
    
}

extension PostUploadViewController: InputAlertViewDelegate {
    func didTapOKButton(_ text: String) {
        DatabaseManager.shared.insertNewHashTag(text) { result in
            switch result {
            case Result.success.rawValue:
                DispatchQueue.main.async {
                    self.alert.configureResultLabel(resultMessage: "Success!", textColor: .systemBlue)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.didTapCancelButton()
                }
            case Result.failure.rawValue:
                DispatchQueue.main.async {
                    self.alert.configureResultLabel(resultMessage: "The hashtag already exists!", textColor: .systemRed)
                }
            default:
                break
            }
        }
    }
    
    func didTapCancelButton() {
        self.alert.clearTextField()
        self.alert.removeFromSuperview()
        self.didTapCaptionOKButton()
    }
    
    
}

