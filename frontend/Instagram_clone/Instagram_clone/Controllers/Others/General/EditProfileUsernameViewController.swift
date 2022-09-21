
import UIKit

class EditProfileUsernameViewController: EditProfileNameViewController {

    private var formerValue = ""
    
    private let textView: UITextView = {
        let textView = UITextView()
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.explantaion1.backgroundColor = .red
        contentView.addSubview(textView)
        contentView.textField.autocapitalizationType = .none
    }
   
    override func configureContents() {
        super.configureContents()
        
        contentView.title.text = "Username"
        contentView.textField.text = value
        contentView.explantaion2.text = ""
        contentView.explantaion1.text = ""
        
        formerValue = getFormerValue()
        textView.attributedText = setNotice(formerValue)
        textView.textColor = .systemGray
        
        textView.delegate = self
        textView.isEditable = false
        
        contentView.textField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navibarHeight = self.navigationController?.navigationBar.height ?? 0
        
        textView.frame = CGRect(x: 25, y: statusBarHeight + navibarHeight - 15, width: contentView.width - 50, height: 100)
    }
    
    private func getFormerValue() -> String {
        if let savedData = UserDefaults.standard.object(forKey: UserDefaults.UserDefaultsKeys.user.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let savedObject = try? decoder.decode(User.self, from: savedData) {
                return savedObject.username
            }
        }
        return ""
    }
    
    private func setNotice(_ formerValue: String) -> NSMutableAttributedString {
        let boldAttribute = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .bold)
        ]
        let regularAttribute = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .light)
        ]
        let boldText = NSAttributedString(string: formerValue, attributes: boldAttribute)
        let regularText = NSAttributedString(string: "In most cases, you'll be able to change your username back to ", attributes: regularAttribute)
        let regularText2 = NSAttributedString(string: " for another 14 days.  ", attributes: regularAttribute)
        
        let link = NSMutableAttributedString(string: "Learn More")
        link.addAttributes([.link : "https://help.instagram.com/876876079327341?cms_id=876876079327341&published_only=true&force_new_ighc=false"], range: NSRange(location: 0, length: link.length))
        
        let newString = NSMutableAttributedString()
        newString.append(regularText)
        newString.append(boldText)
        newString.append(regularText2)
        newString.append(link)
        
        return newString
    }
    
    override func didTapEditProfileNameDoneButton() {
        let username = contentView.textField.text ?? ""
        let user = User(id: 0, username: username, email: "", password: "", emailValidated: false, name: "", bio: "", profileImage: "")
        
        DatabaseManager.shared.canCreateNewUser(user: user) { result in
            if result == "1" {
                if username == self.formerValue {
                    DispatchQueue.main.async {
                        self.proceedEditUsername(username)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.contentView.title.text = "This username isn't available. Please try another."
                        self.contentView.title.textColor = .systemRed
                        self.contentView.title.adjustsFontSizeToFitWidth = true
                    }
                    return
                }
            } else {
                DispatchQueue.main.async {
                    self.proceedEditUsername(username)
                }
            }
        }
    }
    
    private func proceedEditUsername(_ username: String) {
        super.delegate?.changeProfileUsername(username, super.index)
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension EditProfileUsernameViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}

extension EditProfileUsernameViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let username = textField.text ?? ""
        if username.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
}
