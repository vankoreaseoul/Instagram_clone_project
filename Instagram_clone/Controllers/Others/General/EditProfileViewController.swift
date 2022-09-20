
import UIKit

class EditProfileViewController: UIViewController {
    
    enum Result: String {
        case success = "0"
        case fail = "-1"
    }
    
    lazy var editProfileImageMenuView = EditProfileImageMenuView()
    
    private var bioContentHeight: CGFloat?

    struct ProfileCellModel {
        let title: String
        var value: String
        let handler: (String, Int) -> Void
    }
    
    private var menuList = [ProfileCellModel]()
    
    private let headerView: UIView = {
        let headerView = UIView()
        headerView.backgroundColor = .systemBackground
        return headerView
    }()
    
    private let editProfileImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change Profile Photo", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private let profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDoneButtonBlue()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        addSubviews()
        editProfileImageButton.addTarget(self, action: #selector(didTapEditProfileImageButton), for: .touchUpInside)
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        configureMenuList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        assignFrames()
        configureImageView()
   }
    
    private func addSubviews() {
        view.addSubview(headerView)
        view.addSubview(editProfileImageButton)
        view.addSubview(profileTableView)
    }
    
    private func assignFrames() {
        headerView.frame.origin.x = view.safeAreaInsets.left
        headerView.frame.origin.y = view.safeAreaInsets.top
        headerView.frame.size.width = view.width - view.safeAreaInsets.left - view.safeAreaInsets.right
        headerView.frame.size.height = view.height / 5
        
        editProfileImageButton.frame = CGRect(x: (view.width - 200) / 2, y: headerView.bottom, width: 200, height: 30)
        
        profileTableView.frame = CGRect(x: 0, y: editProfileImageButton.bottom + 30, width: view.width - 20, height: view.height - headerView.height - editProfileImageButton.height - 30)
    }
    
    private func configureImageView() {
        if let hasPath = StorageManager.shared.callProfileImagePath() {
            let image = StorageManager.shared.uploadFromDirectory(hasPath)!
            setNewImage(image)
        } else {
            setDefaultImage()
        }
    }
    
    private func setNewImage(_ image: UIImage) {
        let imageView = UIImageView(image: image)
        headerView.addSubview(imageView)
        imageView.frame = CGRect(x: (headerView.width - 140) / 2, y: (headerView.height - 140) / 2, width: 140, height: 140).integral
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 140 / 2.0
    }
    
    private func setDefaultImage() {
        let imageView = UIImageView(image: UIImage(named: "profileImage2"))
        imageView.contentMode = .scaleAspectFit
        headerView.addSubview(imageView)
        imageView.frame = CGRect(x: (headerView.width - 150) / 2, y: (headerView.height - 150) / 2, width: 150, height: 150).integral
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 150 / 2.0
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTapDoneButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancelButton))
        navigationItem.leftBarButtonItem?.tintColor = .systemGray
    }
    
    private func configureMenuList() {
        menuList.append(
            ProfileCellModel(title: "Name", value: "", handler: { text, tagIndex in
            let editProfileNameVC = EditProfileNameViewController()
            editProfileNameVC.value = text
            editProfileNameVC.index = tagIndex
            editProfileNameVC.title = "Name"
            editProfileNameVC.delegate = self
            self.navigationItem.backButtonTitle = ""
            self.navigationController?.navigationBar.tintColor = .black
            self.navigationController?.pushViewController(editProfileNameVC, animated: true)
            })
            )
        menuList.append(
            ProfileCellModel(title: "Username", value: "", handler: { text, tagIndex in
            let editProfileUsernameVC = EditProfileUsernameViewController()
            editProfileUsernameVC.value = text
            editProfileUsernameVC.index = tagIndex
            editProfileUsernameVC.title = "Username"
            editProfileUsernameVC.delegate = self
            self.navigationItem.backButtonTitle = ""
            self.navigationController?.navigationBar.tintColor = .black
            self.navigationController?.pushViewController(editProfileUsernameVC, animated: true)
            })
            )
        menuList.append(
            ProfileCellModel(title: "Bio", value: "", handler: { text, tagIndex in
            let editProfileBioVC = EditProfileBioViewController()
            editProfileBioVC.value = text
            editProfileBioVC.index = tagIndex
            editProfileBioVC.title = "Bio"
            editProfileBioVC.delegate = self
            self.navigationItem.backButtonTitle = ""
            self.navigationController?.navigationBar.tintColor = .black
            self.navigationController?.pushViewController(editProfileBioVC, animated: true)
            })
            )
    }
    
    @objc func didTapDoneButton() {
        let email = StorageManager.shared.callUserInfo()!.email
        let image = (headerView.subviews.first as! UIImageView).image!
        
        if (headerView.subviews.first as! UIImageView).frame.width == 150 { // image default case
            // delete image named email on server storage
            StorageManager.shared.deleteImage(filename: email)
//            var user = StorageManager.shared.callUserInfo()!
//            user.profileImage = ""
//            UserDefaults.standard.setIsSignedIn(value: true, user: user)
            
            // delete image on Mobile Directory and path on UserDefaults
            if let hasPath = StorageManager.shared.callProfileImagePath() {
                StorageManager.shared.deleteAtDirectory(hasPath)
                UserDefaults.standard.setValue(nil, forKey: "background")
            }
            
        } else {
            // save(update) image named email on server storage
            StorageManager.shared.uploadImage(paramName: "file", fileName: email, image: image)
            
            // save image on Mobile Directory and path on UserDefaults
            StorageManager.shared.saveAtDirectory(image: image, imageName: email)
        }
        
        
        // update name, username, bio on database and UserDefaults
        var name = (view.viewWithTag(1) as! UILabel).text!
        let username = (view.viewWithTag(2) as! UILabel).text!
        var bio = (view.viewWithTag(3) as! UILabel).text!
        
        if name == "Name" {
            name = ""
        }
        
        if bio == "Bio" {
            bio = ""
        }
        
        var user = StorageManager.shared.callUserInfo()!
        user.name = name
        user.username = username
        user.bio = bio
        
        DatabaseManager.shared.updateUser(user: user) { result in
            switch result {
            case Result.success.rawValue:
                self.updateUserInfoInUserDefaults(user)
            case Result.fail.rawValue:
                fatalError("Server problem")
            default:
                fatalError("Invalid value")
            }
            
        }
        dismiss(animated: true)
    }
    
    private func updateUserInfoInUserDefaults(_ user: User) {
        UserDefaults.standard.setIsSignedIn(value: true, user: user)
    }

    @objc func didTapCancelButton() {
        self.dismiss(animated: true)
    }
    
    @objc func didTapEditProfileImageButton() {
        presentModal()
    }
    
    private func presentModal() {
        self.navigationController?.view.addSubview(editProfileImageMenuView)
        editProfileImageMenuView.frame = CGRect(x: 0, y: view.height, width: view.width, height: 0)
        editProfileImageMenuView.delegate = self
        
        UIView.animate(withDuration: 0.5,
                         delay: 0, usingSpringWithDamping: 1.0,
                         initialSpringVelocity: 1.0,
                         options: .curveEaseInOut, animations: {
            self.editProfileImageMenuView.frame = self.view.bounds
          }, completion: nil)

    }
    
    @objc func slideUpViewTapped() {
        closeMenuSheet()
    }
    
    private func setValue(_ index: Int) -> String {
        
        enum title: Int {
            case name = 0
            case username = 1
            case bio = 2
        }
        
        switch index {
        case title.name.rawValue:
            return StorageManager.shared.callUserInfo()!.name
        case title.username.rawValue:
            return StorageManager.shared.callUserInfo()!.username
        case title.bio.rawValue:
            return StorageManager.shared.callUserInfo()!.bio
        default:
            fatalError("outOfIndex")
        }
    }
    
    private func setDoneButtonBlue() {
        navigationItem.rightBarButtonItem?.tintColor = .systemBlue
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)], for: .normal)
    }

}

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 30, y: 10, width: 80, height: 30)
        titleLabel.text = menuList[indexPath.row].title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(titleLabel)
        
        let valueLabel = UILabel()
        valueLabel.frame = CGRect(x: 140, y: 10, width: view.width - 170, height: 30)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if setValue(indexPath.row).isEmpty {
            valueLabel.text = menuList[indexPath.row].title
            valueLabel.textColor = .systemGray.withAlphaComponent(0.5)
        } else {
            valueLabel.text = setValue(indexPath.row)
        }
        
        valueLabel.tag = indexPath.row + 1
        valueLabel.font = UIFont.systemFont(ofSize: 18.0)
        
        cell.contentView.addSubview(valueLabel)
        
        
        if indexPath.row == 2 {
            let containerViewHeight: CGFloat = DynamicLabelSize.height(text: valueLabel.text, font: valueLabel.font, width: view.frame.width - 20)
            valueLabel.numberOfLines = 0
            valueLabel.superview?.frame.size.height = containerViewHeight
            valueLabel.frame.size.height = valueLabel.superview!.bounds.height
            
            let cellOfValueLabelHeight = valueLabel.frame.size.height + 20
            bioContentHeight = cellOfValueLabelHeight
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let valueLabel = self.view.viewWithTag(indexPath.row + 1) as! UILabel
        let value = valueLabel.text!
        menuList[indexPath.row].handler(value, indexPath.row + 1)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return bioContentHeight ?? 0.0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    

}

extension EditProfileViewController: EditProfileImageMenuViewDelegate {
    func removeProfileImage() {
        let imageView = headerView.subviews.first as! UIImageView
        imageView.frame = CGRect(x: (headerView.width - 150) / 2, y: (headerView.height - 150) / 2, width: 150, height: 150).integral
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 150 / 2.0
        imageView.contentMode = .scaleAspectFit
        
        imageView.image = UIImage(named: "profileImage2")
    }
    
    func addProfileImage(_ image: UIImage) {
        let imageView = headerView.subviews.first as! UIImageView
        imageView.frame = CGRect(x: (headerView.width - 130) / 2, y: (headerView.height - 130) / 2, width: 130, height: 130).integral
        imageView.layer.cornerRadius = 130 / 2.0
        
        imageView.image = image
    }
    
    func presentLibrary(_ vc: UIViewController) {
        present(vc, animated: true)
    }
    
    func presentCamera(_ vc: UIViewController) {
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func closeMenuSheet() {
          UIView.animate(withDuration: 0.5,
                         delay: 0, usingSpringWithDamping: 1.0,
                         initialSpringVelocity: 1.0,
                         options: .curveEaseInOut, animations: {
              self.editProfileImageMenuView.frame = CGRect(x: 0, y: self.view.height, width: self.view.width, height: 0)
          }, completion: nil)
    }
    
    
}

extension EditProfileViewController: EditProfileNameViewControllerDelegate {
    func changeProfileUsername(_ newUsername: String, _ tagIndex: Int) {
        let valueLabel = self.view.viewWithTag(tagIndex) as! UILabel
        valueLabel.text = newUsername
    }
    
    func changeProfileName(_ newName: String, _ tagIndex: Int) {
        let valueLabel = self.view.viewWithTag(tagIndex) as! UILabel
        valueLabel.text = newName
        if newName.isEmpty {
            valueLabel.text = menuList[tagIndex - 1].title
            valueLabel.textColor = .systemGray.withAlphaComponent(0.5)
        } else {
            valueLabel.textColor = .black.withAlphaComponent(1.0)
        }
    }
    
    func changeProfileBio(_ newBio: String, _ tagIndex: Int) {
        let valueLabel = self.view.viewWithTag(tagIndex) as! UILabel
        valueLabel.text = newBio
        if newBio.isEmpty {
            valueLabel.text = menuList[tagIndex - 1].title
            valueLabel.textColor = .systemGray.withAlphaComponent(0.5)
        } else {
            valueLabel.textColor = .black.withAlphaComponent(1.0)
        }
        
        if tagIndex == 3 {
            let containerViewHeight: CGFloat = DynamicLabelSize.height(text: valueLabel.text, font: valueLabel.font, width: view.frame.width - 20)
            valueLabel.numberOfLines = 0
            valueLabel.superview?.frame.size.height = containerViewHeight
            valueLabel.frame.size.height = valueLabel.superview!.bounds.height
        }
        
        
        let cellOfValueLabel = valueLabel.superview?.superview! as! UITableViewCell
        cellOfValueLabel.frame.size.height = valueLabel.frame.size.height + 20
    }
    
    
}

class DynamicLabelSize {
    static func height(text: String?, font: UIFont, width: CGFloat) -> CGFloat {
        var currentHeight: CGFloat!
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.text = text
        label.font = font
        label.numberOfLines = 0
        label.sizeToFit()
        label.lineBreakMode = .byWordWrapping
        
        currentHeight = label.frame.height
        label.removeFromSuperview()
        
        return currentHeight
    }
}
