
import UIKit

protocol EditProfileNameViewControllerDelegate {
    func changeProfileName(_ newName: String, _ tagIndex: Int)
    func changeProfileBio(_ newBio: String, _ tagIndex: Int)
    func changeProfileUsername(_ newUsername: String, _ tagIndex: Int)
}

class EditProfileNameViewController: UIViewController {

    public var contentView = EditProfilTextView()
    
    var delegate: EditProfileNameViewControllerDelegate?
    
    lazy var value = ""
    
    lazy var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureContents()
        touchView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navibarHeight = self.navigationController?.navigationBar.height ?? 0
        
        let lineView = UIView()
        lineView.backgroundColor = .systemGray.withAlphaComponent(0.5)
        view.addSubview(lineView)
        lineView.frame = CGRect(x: 10, y: statusBarHeight + navibarHeight, width: view.width - 20, height: 1)
        
        contentView.frame = CGRect(x: 0, y: statusBarHeight + navibarHeight, width: view.width, height: view.height / 5)
    }
    
    public func configureContents() {
        contentView.title.text = "Name"
        if value == contentView.title.text {
            contentView.textField.text = ""
        } else {
            contentView.textField.text = value
        }
       
        
        contentView.explantaion1.text = "Help people discover your account by using the name you're known by: either your full name, nickname or business name."
        
        contentView.explantaion2.text = "You can only change your name twice within 14 days."

        view.addSubview(contentView)
    }
    
    private func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapEditProfileNameDoneButton))
        self.navigationItem.rightBarButtonItem?.tintColor = .systemBlue
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
    }
    
    private func touchView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(eliminateKeyboard))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        view.addGestureRecognizer(gesture)
    }
    
    @objc func eliminateKeyboard() {
        contentView.textField.resignFirstResponder()
    }

    @objc func didTapEditProfileNameDoneButton() {
        let newName = contentView.textField.text ?? ""
        delegate?.changeProfileName(newName, index)
        self.navigationController?.popViewController(animated: true)
    }
}
