
import Foundation
import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}

class ImageTimeDict {
    static var share = [NSString : String]()
    private init() {}
}

class BottomTipView: UIView {
    
    private let usernameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(viewColor: UIColor, height: CGFloat, text: String) {
        super.init(frame: .zero)
        self.backgroundColor = viewColor

        let width = configureLabel(text) + 10
        
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: width/2 - 5, y: height))
        path.addLine(to: CGPoint(x: width/2, y: height + 5))
        path.addLine(to: CGPoint(x: width/2 + 5, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = viewColor.cgColor
        
        self.layer.insertSublayer(shape, at: 0)
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 8
    }
    
    public func addLabel() {
        self.addSubview(usernameLabel)
        usernameLabel.center = self.center
        usernameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        usernameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
    }
    
    public func configureLabel(_ text: String) -> CGFloat {
        self.usernameLabel.text = text
        self.usernameLabel.sizeToFit()
        return self.usernameLabel.frame.size.width
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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

extension UIImageView {
    
    func setProfileImage(username: String) {
        DatabaseManager.shared.readUser(username: username, email: nil) { user in
            let profileImagePath = user.profileImage
            if !profileImagePath.isEmpty {
                let url = MainURL.domain + "/download_profile_info"
                var components = URLComponents(string: url)
                let queryPathString = URLQueryItem(name: "pathString", value: profileImagePath)
                components?.queryItems = [queryPathString]
                
                let totalUrl = (components?.url)!
                
                let cacheKey = NSString(string: totalUrl.description)
                
                if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
                    if ImageTimeDict.share[cacheKey] == user.dayString {
                        DispatchQueue.main.async {
                            self.contentMode = .scaleAspectFill
                            self.clipsToBounds = true
                            self.layer.cornerRadius = self.width / 2
                            self.image = cachedImage
                            return
                        }
                    } else {
                        DispatchQueue.global(qos: .background).async {
                            StorageManager.shared.download(profileImagePath) { image in
                                DispatchQueue.main.async {
                                    ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                                    ImageTimeDict.share[cacheKey] = user.dayString
                                    self.contentMode = .scaleAspectFill
                                    self.clipsToBounds = true
                                    self.layer.cornerRadius = self.width / 2
                                    self.image = cachedImage
                                    return
                                }
                            }
                        }
                    }
                } else {
                    DispatchQueue.global(qos: .background).async {
                        StorageManager.shared.download(profileImagePath) { image in
                            DispatchQueue.main.async {
                                ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                                ImageTimeDict.share[cacheKey] = user.dayString
                                self.contentMode = .scaleAspectFill
                                self.clipsToBounds = true
                                self.layer.cornerRadius = self.width / 2
                                self.image = image
                                return
                            }
                        }
                    }
                }

            } else {
                DispatchQueue.main.async {
                    self.image = UIImage(named: "profileImage2")
                }
            }
        }
    }
    
    func setPostImage(username: String, postId: Int) {
        DatabaseManager.shared.readUser(username: username, email: nil) { user in
            let userId = user.id
            let imagePath = "/Users/heawonseo/Desktop/Instagram_image/post/" + userId.description + "/" + postId.description + ".png"
                let url = MainURL.domain + "/download_profile_info"
                var components = URLComponents(string: url)
                let queryPathString = URLQueryItem(name: "pathString", value: imagePath)
                components?.queryItems = [queryPathString]
                
                let totalUrl = (components?.url)!
                
                let cacheKey = NSString(string: totalUrl.description)
                
                if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
                        DispatchQueue.main.async {
                            self.image = cachedImage
                            return
                        }
                } else {
                    DispatchQueue.global(qos: .background).async {
                        StorageManager.shared.download(imagePath) { image in
                            DispatchQueue.main.async {
                                ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                                self.image = image
                                return
                            }
                        }
                    }
                }
        }
        
    }
    
}


