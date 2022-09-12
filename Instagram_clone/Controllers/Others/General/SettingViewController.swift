import UIKit
import SafariServices

final class SettingViewController: UIViewController { // prevent from making subClass
    
    struct SettingCellModel {
        let title: String
        let handler: () -> Void
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var menuList = [[SettingCellModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        configureModels()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureModels() {
        menuList.append([
            SettingCellModel(title: "Terms of Service", handler: { [weak self] in
            self?.openURL(type: .terms)
            }),
            SettingCellModel(title: "Privacy Policy", handler: { [weak self] in
                self?.openURL(type: .privacy)
            }),
            SettingCellModel(title: "Help / Feedback", handler: { [weak self] in
                self?.openURL(type: .help)
            })
                        
        ])
        
        menuList.append([
            SettingCellModel(title: "Sign Out", handler: { [weak self] in
                self?.didTapSignOut()
            })
        ])
    }
    
    enum SettingURLType {
        case terms
        case privacy
        case help
    }
    
    private func openURL(type: SettingURLType) {
        let urlString: String
        switch type {
        case .terms: urlString = "https://help.instagram.com/581066165581870"
        case .privacy: urlString = "https://help.instagram.com/155833707900388"
        case .help: urlString = "https://help.instagram.com"
        }
        guard let url = URL(string: urlString) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    private func didTapSignOut() {
        UserDefaults.standard.set(false, forKey: UserDefaults.UserDefaultsKeys.isSignedIn.rawValue)
        navigationController?.popViewController(animated: true)
        tabBarController?.selectedIndex = 0
    }
    
    
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menuList[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        menuList[indexPath.section][indexPath.row].handler()
    }
    
}
