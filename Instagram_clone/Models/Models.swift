
import Foundation

struct MainURL {
    static let domain = "http://localhost:8080"
}

struct User: Codable {
    let id: Int
    var username: String
    let email: String
    var password: String
    let emailValidated: Bool
    var name: String
    var bio: String
    var profileImage: String
    
    func getUsername() -> String {
        return username;
    }
    
    func getEmail() -> String {
        return email;
    }
    
    func getPassword() -> String {
        return password;
    }
    
    func getName() -> String {
        return name;
    }
    
    func getBio() -> String {
        return bio;
    }
    
    func getProfileImage() -> String {
        return profileImage;
    }
}

struct Post {
    
}
