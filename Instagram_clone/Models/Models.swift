
import Foundation

struct MainURL {
    static let domain = "http://localhost:8080"
}

struct User {
    let username: String
    let email: String
    let password: String
    
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
