
import SafariServices
import UIKit

struct Constants {
    static let cornerRadius: CGFloat = 8.0
}

class SignInViewController: UIViewController {
    
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
   
    func addTargetOnButtons() {
        signinButton.addTarget(self, action: #selector(didTapSigninButton), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccountButton), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTermsButton), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(didTapPrivacyButton), for: .touchUpInside)
    }
    
    @objc func didTapSigninButton() {
        // so many things to do
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
    
    
}
