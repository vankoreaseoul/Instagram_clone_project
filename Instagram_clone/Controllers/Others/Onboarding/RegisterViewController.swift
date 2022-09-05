
import UIKit

class RegisterViewController: UIViewController {

    enum Result: String {
        case success = "0"
        case duplicateUsername = "1"
        case duplicateEmail = "2"
    }
    
    private let usernameField: UITextField = {
        let field = UITextField()
        field.setTextField(placeholder: "Username..")
        field.returnKeyType = .next
        return field
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Required"
        label.textColor = .systemRed
        label.font = label.font.withSize(13)
        return label
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.setTextField(placeholder: "Email..")
        field.returnKeyType = .next
        return field
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Required"
        label.textColor = .systemRed
        label.font = label.font.withSize(13)
        return label
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.setTextField(placeholder: "Password..")
        field.returnKeyType = .continue
        field.isSecureTextEntry = true
        return field
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Required"
        label.textColor = .systemRed
        label.numberOfLines = 3
        label.font = label.font.withSize(13)
        return label
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.cornerRadius
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        addSubviews()
        resetForm()
        
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        assignFrames()
    }
    
    func assignFrames() {
        usernameField.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 50, width: view.width - 40, height: 52)
        usernameLabel.frame = CGRect(x: 20, y: usernameField.bottom, width: view.width - 40, height: 52)
        emailField.frame = CGRect(x: 20, y: usernameLabel.bottom + 10, width: view.width - 40, height: 52)
        emailLabel.frame = CGRect(x: 20, y: emailField.bottom, width: view.width - 40, height: 52)
        passwordField.frame = CGRect(x: 20, y: emailLabel.bottom + 10, width: view.width - 40, height: 52)
        passwordLabel.frame = CGRect(x: 20, y: passwordField.bottom, width: view.width - 40, height: 60)
        registerButton.frame = CGRect(x: 20, y: passwordLabel.bottom + 10, width: view.width - 40, height: 52)
    }
    
    func addSubviews() {
        view.addSubview(usernameField)
        view.addSubview(usernameLabel)
        view.addSubview(emailField)
        view.addSubview(emailLabel)
        view.addSubview(passwordField)
        view.addSubview(passwordLabel)
        view.addSubview(registerButton)
        touchView()
        
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
    }
    
    func resetForm() {
        registerButton.isEnabled = false
        registerButton.backgroundColor = .systemGray
        registerButton.alpha = 0.3
        
        usernameLabel.isHidden = false
        emailLabel.isHidden = false
        passwordLabel.isHidden = false
        
        usernameLabel.text = "Required"
        emailLabel.text = "Required"
        passwordLabel.text = "Required"
        
        usernameField.text = ""
        emailField.text = ""
        passwordField.text = ""
    }
    
    private func touchView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(eliminateKeyboard))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        view.addGestureRecognizer(gesture)
    }
    
    @objc func eliminateKeyboard() {
        emailField.resignFirstResponder()
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    @objc func didTapRegister() {
        emailField.resignFirstResponder()
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()

        let url = MainURL.domain + "/user/signup"
        var components = URLComponents(string: url)
        let queryUsername = URLQueryItem(name: "username", value: usernameField.text)
        let queryEmail = URLQueryItem(name: "email", value: emailField.text)
        let queryPassword = URLQueryItem(name: "password", value: passwordField.text)
        components?.queryItems = [queryUsername, queryEmail, queryPassword]

        let totalUrl = (components?.url)!

        let task = URLSession.shared.dataTask(with: totalUrl) {(data, response, error) in
            guard let data = data else { return }
            let result = String(data: data, encoding: .utf8)!

            switch result {
            case Result.success.rawValue:
                DispatchQueue.main.async {
                    self.showEmailCheckAlertMessage()
                }
            case Result.duplicateUsername.rawValue :
                DispatchQueue.main.async {
                    self.showAlertMessage(title: "Sorry!", message: "The username already exists") { [weak self] in
                        self?.usernameField.text = ""
                        self?.usernameLabel.text = "Required"
                        self?.usernameLabel.isHidden = false
                    }
                    return
                }
            case Result.duplicateEmail.rawValue:
                DispatchQueue.main.async {
                    self.showAlertMessage(title: "Sorry!", message: "The email address already exists") { [weak self] in
                        self?.emailField.text = ""
                        self?.emailLabel.text = "Required"
                        self?.emailLabel.isHidden = false
                    }
                    return
                }
            default:
                fatalError("unknown value")
            }
        }

        task.resume()
    }
    
    func showEmailCheckAlertMessage() {
        let sheet = UIAlertController(title: "Success", message: "Please check your email and put code to validate your account", preferredStyle: .alert)
        
        sheet.addTextField { field in
            field.placeholder = "Code"
            field.textAlignment = .center
        }
        sheet.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            guard let fields = sheet.textFields else {
                return
            }
            let codeField = fields[0]
            guard let hasValue = codeField.text, !hasValue.isEmpty else {
                return
            }
            // Check hasValue and codeValue
        }))
        self.present(sheet, animated: true)
    }
    
    
    func showAlertMessage( title: String?, message: String, completion: ( () -> Void )? ) {
        let sheet = UIAlertController(title: title, message: message, preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            guard let hasCompletion = completion else {
                return
            }
            hasCompletion()
        }))
        self.present(sheet, animated: true)
    }
    
    private func isValidUsername(value: String) -> String? {
        let usernameRegax = "^[a-zA-Z0-9]+$"
        let usernameCheck = NSPredicate(format: "SELF MATCHES %@", usernameRegax)
        if !usernameCheck.evaluate(with: value) {
            return "Username must contain only English alphabet or number"
        }
        if value.count < 3 {
            return "Username must be over than 2 in Length "
        }
        return nil
    }
    
    private func isValidEmail(value: String) -> String? {
        let emailRegax = "[A-Z0-9a-z. %+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailCheck = NSPredicate(format:"SELF MATCHES %@", emailRegax)
        if !emailCheck.evaluate(with: value) {
            return "Invalid Emaill Address"
        }
        return nil
    }
    
    private func isValidPassword(value: String) -> String? {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[A-Za-z\\d$@$!%*?&#]{8,10}"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        if !passwordCheck.evaluate(with: value) {
            return "Minimum 8 and Maximum 10 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character"
        }
        return nil
    }
    
    func checkAllValidForms() {
        if usernameLabel.isHidden && emailLabel.isHidden && passwordLabel.isHidden {
            registerButton.isEnabled = true
            registerButton.backgroundColor = .systemGreen
            registerButton.alpha = 1.0
        } else {
            registerButton.isEnabled = false
            registerButton.backgroundColor = .systemGray
            registerButton.alpha = 0.3
        }
    }

    func usernameFieldChanged() {
        guard let hasValue = usernameField.text else {
            return
        }
        if let message = isValidUsername(value: hasValue) {
            usernameLabel.text = message
            usernameLabel.isHidden = false
        } else {
            usernameLabel.isHidden = true
        }
        checkAllValidForms()
    }
    
    func emailFieldChanged() {
        guard let hasValue = emailField.text else {
            return
        }
        if let message = isValidEmail(value: hasValue) {
            emailLabel.text = message
            emailLabel.isHidden = false
        } else {
            emailLabel.isHidden = true
        }
        checkAllValidForms()
    }
    
    func passwordFieldChanged() {
        guard let hasValue = passwordField.text else {
            return
        }
        if let message = isValidPassword(value: hasValue) {
            passwordLabel.text = message
            passwordLabel.isHidden = false
        } else {
            passwordLabel.isHidden = true
        }
        checkAllValidForms()
    }
    
}


extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == usernameField {
            usernameFieldChanged()
        }
        if textField == emailField {
            emailFieldChanged()
        }
        if textField == passwordField {
            passwordFieldChanged()
        }
    }
}
