
import Foundation

enum UserResult: String {
    case success = "0"
    case duplicateUsername = "1"
    case duplicateEmail = "2"
    case error = "-1"
}

enum Result: String {
    case success = "0"
    case failure = "1"
}

class AuthManager {
    
    static let shared = AuthManager()
    
    public func registerNewUser( user: User, completion: @escaping (String) -> Void ) {
        DatabaseManager.shared.canCreateNewUser(user: user) { result in
            switch result {
            case UserResult.success.rawValue:
                DatabaseManager.shared.insert(user: user) { result in
                    switch result {
                    case UserResult.success.rawValue:
                        completion("0")
                    default:
                        completion("-1")
                    }
                }
            case UserResult.duplicateUsername.rawValue:
                completion("1")
            case UserResult.duplicateEmail.rawValue:
                completion("2")
            default:
                completion("-1")
            }
        }
    }
    
    public func validateEmail( email: String, completion: @escaping (String) -> Void ) {
        MailManager.shared.sendEmail(email: email) { result in
            switch result {
            case Result.success.rawValue:
                completion("0")
            default:
                completion("1")
            }
        }
    }
    
    public func validateCode( email: String, code: String, completion: @escaping (String) -> Void ) {
        MailManager.shared.sendCode(email: email, code: code) { result in
            switch result {
            case Result.success.rawValue:
                completion("0")
            default:
                completion("1")
            }
        }
    }
    
    
    
}
