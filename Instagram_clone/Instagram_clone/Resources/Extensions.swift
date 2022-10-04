
import Foundation
import UIKit

extension UITextField {
    
    func addLeftPadding() {
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: 10, height: self.frame.height)
        self.leftView = leftView
        self.leftViewMode = .always
    }
    
    func setTextField(placeholder: String) {
        self.placeholder = placeholder
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.secondaryLabel.cgColor
        self.addLeftPadding()
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = Constants.cornerRadius
        self.layer.masksToBounds = true
    }
    
}

extension UIView {
    
    public var width: CGFloat {
        return self.frame.size.width
    }
    
    public var height: CGFloat {
        return self.frame.size.height
    }
    
    public var top: CGFloat {
        return self.frame.origin.y
    }
    
    public var bottom: CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
    
    public var left: CGFloat {
        return self.frame.origin.x
    }
    
    public var right: CGFloat {
        return self.frame.origin.x + self.frame.size.width
    }
}

extension UIViewController {
    
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
    
    
}

extension UserDefaults {
    enum UserDefaultsKeys: String {
        case isSignedIn
        case user
    }
    
    func setIsSignedIn(value: Bool, user: User?) {
        self.set(value, forKey: UserDefaultsKeys.isSignedIn.rawValue)
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            self.set(encoded, forKey: UserDefaultsKeys.user.rawValue)
        }
        
        self.synchronize()
    }
    
    func isSignedIn() -> Bool {
        return self.bool(forKey: UserDefaultsKeys.isSignedIn.rawValue)
    }
    
}




