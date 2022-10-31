
import UIKit

protocol ExploreViewControllerDelegate {
    func enrollTaggedPeople(_ person: (String, String))
}

class ExploreViewController: UIViewController {
    
    var delegate: ExploreViewControllerDelegate?
    
    private var searchIndex = 0 // 0: people, 1: tags
    
    private let searchController = UISearchController()
    
    private var data = [(String, String)]()
    
    private let peopleButton: UIButton = {
       let button = UIButton()
        button.setTitle("People", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.isHidden = true
        button.isEnabled = false
        return button
    }()
    
    private let tagsButton: UIButton = {
       let button = UIButton()
        button.setTitle("Tags", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.isHidden = true
        button.isEnabled = false
        return button
    }()
    
    private let blueLine: UIView = {
        let line =  UIView()
        line.backgroundColor = .systemBlue
        line.isHidden = true
        return line
    }()
    
    private let blackLine: UIView = {
        let line =  UIView()
        line.backgroundColor = .systemGray.withAlphaComponent(0.3)
        line.isHidden = true
        return line
    }()
    
    private var tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(PeopleTableViewCell.self, forCellReuseIdentifier: PeopleTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureSearchBar()
        addSubViews()
        addButtonAction()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        assignFrames()
        
        if delegate != nil {
            changeForm()
        }
    }
    
    private func configureSearchBar() {
        self.definesPresentationContext = true
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.returnKeyType = .done
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func addSubViews() {
        view.addSubview(peopleButton)
        view.addSubview(tagsButton)
        view.addSubview(blueLine)
        view.addSubview(blackLine)
        view.addSubview(tableView)
    }
    
    private func assignFrames() {
        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0
        peopleButton.frame = CGRect(x: 0, y: 75, width: view.width / 2, height: 30)
        tagsButton.frame = CGRect(x: peopleButton.right, y: 75, width: view.width / 2, height: 30)
        blueLine.frame = CGRect(x: 0, y: peopleButton.bottom + 5, width: view.width / 2, height: 3)
        blackLine.frame = CGRect(x: 0, y: self.peopleButton.bottom + 8, width: self.view.width, height: 2)
        tableView.frame = CGRect(x: 0, y: blackLine.bottom, width: self.view.width, height: self.view.height - blackLine.bottom - tabBarHeight)
    }
    
    private func showMenuBar() {
        UIView.transition(with: peopleButton, duration: 0.8,
                          options: .transitionCrossDissolve,
                          animations: {
            self.peopleButton.isHidden = false
            self.peopleButton.isEnabled = true
                      })
        UIView.transition(with: tagsButton, duration: 0.8,
                          options: .transitionCrossDissolve,
                          animations: {
            self.tagsButton.isHidden = false
            self.tagsButton.isEnabled = true
                      })
        UIView.transition(with: blackLine, duration: 0.8,
                          options: .transitionCrossDissolve,
                          animations: {
            self.blackLine.isHidden = false
                      })
        UIView.transition(with: blueLine, duration: 0.8,
                          options: .transitionCrossDissolve,
                          animations: {
            self.blueLine.isHidden = false
                      })
    }
    
    private func removeMenuBar() {
        UIView.transition(with: peopleButton, duration: 1.5,
                          options: .transitionCrossDissolve,
                          animations: {
            self.peopleButton.isHidden = true
            self.peopleButton.isEnabled = false
                      })
        UIView.transition(with: tagsButton, duration: 1.5,
                          options: .transitionCrossDissolve,
                          animations: {
            self.tagsButton.isHidden = true
            self.tagsButton.isEnabled = false
                      })
        UIView.transition(with: blueLine, duration: 1.5,
                          options: .transitionCrossDissolve,
                          animations: {
            self.blueLine.isHidden = true
                      })
        UIView.transition(with: blackLine, duration: 0.8,
                          options: .transitionCrossDissolve,
                          animations: {
            self.blackLine.isHidden = true
                      })
    }
    
    private func addButtonAction() {
        peopleButton.addTarget(self, action: #selector(didTapPeopleMenu), for: .touchUpInside)
        tagsButton.addTarget(self, action: #selector(didTapTagsMenu), for: .touchUpInside)
    }
    
    @objc func didTapPeopleMenu() {
        blueLine.frame.origin.x = 0
        peopleButton.setTitleColor(.systemBlue, for: .normal)
        tagsButton.setTitleColor(.black, for: .normal)
        
        if searchIndex == 1 {
            self.data.removeAll()
            self.tableView.reloadData()
            self.searchController.searchBar.text = ""
        }
        
        searchIndex = 0
    }
    
    @objc func didTapTagsMenu() {
        blueLine.frame.origin.x = peopleButton.right
        peopleButton.setTitleColor(.black, for: .normal)
        tagsButton.setTitleColor(.systemBlue, for: .normal)
        
        if searchIndex == 0 {
            self.data.removeAll()
            self.tableView.reloadData()
            self.searchController.searchBar.text = ""
        }
        
        searchIndex = 1
    }
    
    private func searchPeople(_ keyword: String) {
        DatabaseManager.shared.searchUsers(username: keyword) { data in
            self.data = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func searchHashTag(_ keyword: String) {
        DatabaseManager.shared.searchHashTag(keyword) { hashTags in
            var data = [(String, String)]()
            for hashtag in hashTags {
                data.append((hashtag.name, ""))
            }
            self.data = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func changeForm() {
        self.peopleButton.frame.size = .zero
        self.tagsButton.frame.size = .zero
        self.blueLine.frame.size = .zero
        self.blackLine.frame.size = .zero
        self.tableView.frame.origin.y = -50
        self.searchController.isActive = true
    }
    
    
}

extension ExploreViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
}

extension ExploreViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if !searchController.isActive {
            if delegate != nil {
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            } else {
                removeMenuBar()
            }
        }
        guard let hasText = searchController.searchBar.text else {
            return
        }
        if !hasText.isEmpty {
            let keyword = hasText.lowercased()
            if searchIndex == 0 {
                searchPeople(keyword)
            } else {
                searchHashTag(keyword)
            }
        } else {
            data.removeAll()
            tableView.reloadData()
        }
        
        
    }
    
}

extension ExploreViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        showMenuBar()
        return true
    }
    
}

extension ExploreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PeopleTableViewCell.identifier, for: indexPath) as! PeopleTableViewCell
        
        if searchIndex == 0 {
            cell.profileImageView.image = UIImage(named: "profileImage2")
            
            // let imagePath = data[indexPath.row].1
            let username = data[indexPath.row].0
            
            cell.profileImageView.setProfileImage(username: username)
            cell.configureUsername(username)
        } else {
            cell.profileImageView.image = UIImage(named: "hashTag")
            let hashtagName = data[indexPath.row].0
            cell.configureUsername(hashtagName)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if searchIndex == 0 {
            if delegate == nil {
                let selectedUsername = data[indexPath.row].0
                let username = StorageManager.shared.callUserInfo()!.username
                
                if username == selectedUsername {
                    self.tabBarController?.selectedIndex = 4
                } else {
                    let profileVC = ProfileViewController()
                    profileVC.index = 1
                    DatabaseManager.shared.readUser(username: selectedUsername, email: nil) { user in
                        DispatchQueue.main.async {
                            profileVC.user = user
                            self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
                            self.navigationController?.navigationBar.tintColor = .black
                            self.navigationController?.pushViewController(profileVC, animated: true)
                        }
                    }
                }
            } else {
                delegate?.enrollTaggedPeople(data[indexPath.row])
                self.dismiss(animated: true)
            }
        } else {
            let hashtagDisplayVC = HashtagDisplayViewController()
            let hashtagName = data[indexPath.row].0
            hashtagDisplayVC.title = hashtagName
            
            DatabaseManager.shared.readHashTag(hashtagName) { hashtag in
                let hashtagId = hashtag.id
                DatabaseManager.shared.readHashtagPosts(hashtagId) { posts in
                    hashtagDisplayVC.data = posts
                    DispatchQueue.main.async {
                        hashtagDisplayVC.reloadCollectionView()
                    }
                }
            }
            self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
            self.navigationController?.navigationBar.tintColor = .black
            self.navigationController?.pushViewController(hashtagDisplayVC, animated: true)
            
        }
    }
    
    
}
