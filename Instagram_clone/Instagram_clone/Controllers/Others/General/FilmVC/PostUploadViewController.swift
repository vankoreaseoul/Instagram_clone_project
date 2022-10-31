
import UIKit
import GooglePlaces

class PostUploadViewController: UIViewController {
    
    struct model {
        let title: String
        let handler: () -> Void
    }
    
    private var locationView: UIView?
    
    private var tagPeople: [(String, String)]?
    
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
        dummyView.backgroundColor = .darkGray.withAlphaComponent(0.5)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCaptionOKButton))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        dummyView.addGestureRecognizer(gesture)
        
        dummyView.frame = CGRect(x: 0, y: self.view.height, width: self.view.width, height: 0)
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.dummyView.frame = CGRect(x: 0, y: self.captionViewLine.bottom, width: self.view.width, height: self.view.height - self.captionViewLine.bottom)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(didTapCaptionOKButton))
        self.title = "Caption"
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    @objc private func didTapCaptionOKButton() {
        self.navigationItem.setHidesBackButton(false, animated: false)
        self.title = "New Post"
        self.configureNaviBar()
        dummyView.removeFromSuperview()
        textView.resignFirstResponder()
        self.textView.sizeToFit()
    }
    
    private func searchMention(_ keyword: String) {
        print("@ call")
        // set friend list on dummyView
    }
    
    private func searchHashTag(_ keyword: String) {
        print("# call")
        // set hashTag theme list on dummyView
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
        if textView.text.contains("#") {
            var word = textView.text.components(separatedBy: "#").last!
            if word.contains("\n") || word.contains("@") {
                return
            }
            word = word.trimmingCharacters(in: .whitespaces)
            self.searchHashTag(word)
        }
        
        if textView.text.contains("@") {
            var word = textView.text.components(separatedBy: "@").last!
            if word.contains("\n") || word.contains("#") {
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
            print(locationView!)
            return
        }
        print(2)
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

