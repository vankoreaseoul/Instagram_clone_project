
import Foundation

struct MainURL {
    static let domain = "http://localhost:8080"
}

struct User: Decodable {
    let id: Int
    let username: String
    let email: String
    let password: String
    let emailValidated: Bool
    
    func getUsername() -> String {
        return username;
    }
    
    func getEmail() -> String {
        return email;
    }
    
    func getPassword() -> String {
        return password;
    }
}
