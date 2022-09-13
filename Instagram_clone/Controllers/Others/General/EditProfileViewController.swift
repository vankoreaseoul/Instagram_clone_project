
import UIKit

class EditProfileViewController: UIViewController {

    struct ProfileCellModel {
        let title: String
        let handler: () -> Void
    }
    
    private var menuList = [ProfileCellModel]()
    
    private let headerView: UIView = {
        let headerView = UIView()
        headerView.backgroundColor = .systemRed
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
        menuList.append(ProfileCellModel(title: "Name", handler: { [weak self] in
            //UINavigationController(rootViewController: self).pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: true)
        }))
    }
    
    @objc func didTapDoneButton() {
        // save changes
    }
    
    @objc func didTapCancelButton() {
        self.dismiss(animated: true)
    }
    
    @objc func didTapEditProfileImageButton() {
        // approach gallery
    }

}

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
