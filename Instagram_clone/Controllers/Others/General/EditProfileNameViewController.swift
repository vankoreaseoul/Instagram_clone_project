
import UIKit

class EditProfileNameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapEditProfileNameButton))
        self.navigationItem.rightBarButtonItem?.tintColor = .systemBlue
    }
    

    @objc func didTapEditProfileNameButton() {
        print(1)
    }
}
