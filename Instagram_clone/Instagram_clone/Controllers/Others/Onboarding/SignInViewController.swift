
import SafariServices
import UIKit

struct Constants {
    static let cornerRadius: CGFloat = 8.0
}

class SignInViewController: UIViewController {
   
    lazy var sheet = UIAlertController()
    lazy var yesAction = UIAlertAction()
    
    private let header: UIView = {
        let header = UIView()
        let backgroundImageView = UIImageView(image: UIImage(named: "signinHeaderImage"))
        header.addSubview(backgroundImageView)
        header.clipsToBounds = true
        return header
    }()
    
    private let usernameOrEmailField: UITextField = {
        let field = UITextField()
        field.setTextField(placeholder: "Username or Email..")
        field.returnKeyType = .next
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.setTextField(placeholder: "Password..")
        field.returnKeyType = .continue
        field.isSecureTextEntry = true
        return field
    }()
    
    private let signinButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Sign in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.cornerRadius
        button.layer.masksToBounds = true
        return button
    }()
    
    private let termsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Terms of Service", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    private let privacyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Privacy Policy", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("New User? Create an Account", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubViews()
        resetAllField()
        touchView()
        
        usernameOrEmailField.delegate = self
        passwordField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        assignFrames()
    }
    
    func addSubViews() {
        view.addSubview(header)
        view.addSubview(usernameOrEmailField)
        view.addSubview(passwordField)
        view.addSubview(signinButton)
        view.addSubview(termsButton)
        view.addSubview(privacyButton)
        view.addSubview(createAccountButton)
        
        addTargetOnButtons()
    }
    
    func assignFrames() {
        header.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height / 3)
        usernameOrEmailField.frame = CGRect(x: 25, y: header.bottom + 40, width: view.width - 50, height: 52.0)
        passwordField.frame = CGRect(x: 25, y: usernameOrEmailField.bottom + 10, width: view.width - 50, height: 52.0)
        signinButton.frame = CGRect(x: 25, y: passwordField.bottom + 10, width: view.width - 50, height: 52.0)
        createAccountButton.frame = CGRect(x: 25, y: signinButton.bottom + 10, width: view.width - 50, height: 52.0)
        
        termsButton.frame = CGRect(x: 10, y: view.height - view.safeAreaInsets.bottom - 100, width: view.width - 20, height: 50)
        privacyButton.frame = CGRect(x: 10, y: view.height - view.safeAreaInsets.bottom - 50, width: view.width - 20, height: 50)
        
        configureHeader()
    }
    
    private func touchView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(eliminateKeyboard))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        view.addGestureRecognizer(gesture)
    }
    
    @objc func eliminateKeyboard() {
        usernameOrEmailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    func resetAllField() {
        usernameOrEmailField.text = ""
        passwordField.text = ""
        signinButton.isEnabled = false
        signinButton.backgroundColor = .systemGray
        signinButton.alpha = 0.3
    }
    
    
   
    func addTargetOnButtons() {
        signinButton.addTarget(self, action: #selector(didTapSigninButton), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccountButton), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTermsButton), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(didTapPrivacyButton), for: .touchUpInside)
    }
    
    @objc func didTapSigninButton() {
        let usernameOrEmail = usernameOrEmailField.text!
        let password = passwordField.text!
        AuthManager.shared.signIn(usernameOrEmail, password) { result in
            switch result {
            case SignInResult.success.rawValue :
                DispatchQueue.main.async {
                    self.addUserInfoOnSessionAndChangePage()
                }
            case SignInResult.emailNotValidated.rawValue:
                    if !usernameOrEmail.contains("@"){
                        DatabaseManager.shared.readUser(username: usernameOrEmail, email: nil) { user in
                            DispatchQueue.main.async {
                                self.showEmailCheckAlertMessage(email: user.email) {
                                    self.addUserInfoOnSessionAndChangePage()
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showEmailCheckAlertMessage(email: usernameOrEmail) {
                                self.addUserInfoOnSessionAndChangePage()
                            }
                        }
                    }
            case SignInResult.wrongPassword.rawValue:
                DispatchQueue.main.async {
                    self.showAlertMessage(title: nil, message: "Please check your password again!") { [weak self] in
                        self?.passwordField.text = ""
                        self?.signinButtonStateChange()
                    }
                }
            case SignInResult.accountNotExist.rawValue:
                DispatchQueue.main.async {
                    self.showAlertMessage(title: nil, message: "The account doesn't exist! Please sign up first!") { [weak self] in
                        self?.usernameOrEmailField.text = ""
                        self?.passwordField.text = ""
                        self?.signinButtonStateChange()
                    }
                }
            default:
                fatalError("Server error")
            }
        }
    }
    
    @objc func didTapCreateAccountButton() {
        let registerVC = RegisterViewController()
        registerVC.title = "Create Account"
        self.present(UINavigationController(rootViewController: registerVC), animated: true)
    }
    
    @objc func didTapTermsButton() {
        guard let hasUrl = URL(string: "https://help.instagram.com/581066165581870") else { return }
        let vc = SFSafariViewController(url: hasUrl)
        self.present(vc, animated: true)
    }
    
    @objc func didTapPrivacyButton() {
        guard let hasUrl = URL(string: "https://help.instagram.com/155833707900388") else { return }
        let vc = SFSafariViewController(url: hasUrl)
        self.present(vc, animated: true)
    }
    
    func configureHeader() {
        guard let backgroundImageView = header.subviews.first else {
            return
        }
        backgroundImageView.frame = header.bounds
        
        let imageView = UIImageView(image: UIImage(named: "text"))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: backgroundImageView.width/4.0, y: view.safeAreaInsets.top, width: backgroundImageView.width/2.0, height: backgroundImageView.height - view.safeAreaInsets.top)
        backgroundImageView.addSubview(imageView)
        
    }
    
    func signinButtonStateChange() {
        if (usernameOrEmailField.text?.count ?? 0 > 0 && passwordField.text?.count ?? 0 > 0) {
            signinButton.isEnabled = true
            signinButton.backgroundColor = .systemBlue
            signinButton.alpha = 1.0
        } else {
            signinButton.isEnabled = false
            signinButton.backgroundColor = .systemGray
            signinButton.alpha = 0.3
        }
        
    }
    
    func showEmailCheckAlertMessage( email: String, completion: @escaping () -> Void ) {
        sheet = UIAlertController(title: nil, message: "Please check your email and put code to validate your account", preferredStyle: .alert)
        
        sheet.addTextField { field in
            field.placeholder = "Code"
            field.textAlignment = .center
            field.addTarget(self, action: #selector(self.alertTextFieldChanged), for: .editingChanged)
        }
        
        yesAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            guard let fields = self.sheet.textFields else {
                return
            }
            let codeField = fields[0]
            guard let hasValue = codeField.text, !hasValue.isEmpty else {
                return
            }
           
            AuthManager.shared.validateCode(email: email, code: hasValue) { result in
                switch result {
                case Result.success.rawValue:
                    DispatchQueue.main.async {
                        self.showAlertMessage(title: "Success", message: "The account is validated") {
                            completion()
                        }
                    }
                default:
                    DispatchQueue.main.async {
                        self.showAlertMessage(title: "Failure", message: "Please check the code again!") { [weak self] in
                            self?.showEmailCheckAlertMessage(email: email, completion: completion)
                        }
                    }
                }
            }
            
        })
        
        let noAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.usernameOrEmailField.text = ""
            self.passwordField.text = ""
        }
        
        yesAction.isEnabled = false
        sheet.addAction(yesAction)
        sheet.addAction(noAction)
        
        self.present(sheet, animated: true)
    }
    
    @objc func alertTextFieldChanged() {
        yesAction.isEnabled = sheet.textFields?.first!.text!.count ?? 0 > 0
    }
    
    func addUserInfoOnSessionAndChangePage() {
        if usernameOrEmailField.text!.contains("@") {
            DatabaseManager.shared.readUser(username: nil, email: usernameOrEmailField.text) { user in
                if !user.profileImage.isEmpty {
                    StorageManager.shared.download(user.profileImage) { image in
                        DispatchQueue.main.async {
                            StorageManager.shared.saveAtDirectory(image: image, imageName: user.email)
                            print(UserDefaults.standard.url(forKey: "background")!.description)
                        }
                    }
                }
                
                UserDefaults.standard.setIsSignedIn(value: true, user: user)
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            }
        } else {
            DatabaseManager.shared.readUser(username: usernameOrEmailField.text, email: nil) { user in
                print(user)
                
                    if !user.profileImage.isEmpty {
                        StorageManager.shared.download(user.profileImage) { image in
                            DispatchQueue.main.async {
                                StorageManager.shared.saveAtDirectory(image: image, imageName: user.email)
                                print(UserDefaults.standard.url(forKey: "background")!.description)
                            }
                        }
                    }
                
                UserDefaults.standard.setIsSignedIn(value: true, user: user)
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    
    
    
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        signinButtonStateChange()
    }
}

extension SignInViewController {
    enum SignInResult: String {
        case success = "0"
        case emailNotValidated = "1"
        case wrongPassword = "2"
        case accountNotExist = "3"
        case error = "-1"
    }
}
