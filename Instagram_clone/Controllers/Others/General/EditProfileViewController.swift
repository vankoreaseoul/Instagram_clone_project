
import UIKit

class EditProfileViewController: UIViewController {
    
    lazy var editProfileImageMenuView = EditProfileImageMenuView()

    struct ProfileCellModel {
        let title: String
        let handler: () -> Void
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
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
        
        profileTableView.frame = CGRect(x: 0, y: editProfileImageButton.bottom + 30, width: view.width, height: view.height - headerView.height - editProfileImageButton.height - 30)
    }
    
    private func configureImageView() {
        if let savedData = UserDefaults.standard.object(forKey: UserDefaults.UserDefaultsKeys.user.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let savedObject = try? decoder.decode(User.self, from: savedData) {
                if !savedObject.profileImage.isEmpty {
                    // set image
                    print(1)
                } else {
                    setDefaultImage()
                }
            }
        }
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
            ProfileCellModel(title: "Name", handler: {
            let editProfileNameVC = EditProfileNameViewController()
            editProfileNameVC.title = "Name"
            self.navigationItem.backButtonTitle = ""
            self.navigationController?.navigationBar.tintColor = .black
            self.navigationController?.pushViewController(editProfileNameVC, animated: true)
            })
            )
        menuList.append(
            ProfileCellModel(title: "Username", handler: {
            let editProfileUsernameVC = EditProfileUsernameViewController()
            editProfileUsernameVC.title = "Username"
            self.navigationItem.backButtonTitle = ""
            self.navigationController?.navigationBar.tintColor = .black
            self.navigationController?.pushViewController(editProfileUsernameVC, animated: true)
            })
            )
        menuList.append(
            ProfileCellModel(title: "Bio", handler: {
            let editProfileBioVC = EditProfileBioViewController()
            editProfileBioVC.title = "Bio"
            self.navigationItem.backButtonTitle = ""
            self.navigationController?.navigationBar.tintColor = .black
            self.navigationController?.pushViewController(editProfileBioVC, animated: true)
            })
            )
    }
    
    @objc func didTapDoneButton() {
        // save changes
        
            // image
                // save userDefaults
                // save dataBase
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

}

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menuList[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        menuList[indexPath.row].handler()
    }
}

extension EditProfileViewController: EditProfileImageMenuViewDelegate {
    func addProfileImage(_ image: UIImage) {
        let imageView = headerView.subviews.first as! UIImageView
        imageView.frame = CGRect(x: (headerView.width - 130) / 2, y: (headerView.height - 130) / 2, width: 130, height: 130).integral
        imageView.layer.cornerRadius = 130 / 2.0
        
        imageView.image = image
    }
    
    func presentLibrary(_ vc: UIViewController) {
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
