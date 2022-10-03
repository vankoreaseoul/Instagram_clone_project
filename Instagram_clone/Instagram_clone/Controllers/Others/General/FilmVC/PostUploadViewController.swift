
import UIKit

class PostUploadViewController: UIViewController {
    
    struct model {
        let title: String
        let handler: () -> Void
    }
    
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
                let tagPeopleNC = UINavigationController(rootViewController: tagPeopleVC)
                tagPeopleNC.modalPresentationStyle = .fullScreen
                self?.present(tagPeopleNC, animated: true)
            })
        )
        modelList.append(
            model(title: "Add Location") { [weak self] in
                let testVC = UIViewController()
                self?.present(testVC, animated: true)
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
        modelList[indexPath.row].handler()
    }
}

