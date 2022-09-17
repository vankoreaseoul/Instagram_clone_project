
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
        // check duplication and show message here
        
        // message: "This username isn't available. Please try another.(Red)"
        
        
        var username = contentView.textField.text ?? ""
        if username.isEmpty {
            username = formerValue
        }
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
