
import UIKit

final class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettingButton))
        self.navigationItem.rightBarButtonItem?.tintColor = .systemGray
    }
    
    @objc func didTapSettingButton() {
        let settingVC = SettingViewController()
        settingVC.title = "Settings"
        navigationController?.pushViewController(settingVC, animated: true)
    }
}
