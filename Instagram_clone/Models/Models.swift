
import Foundation

struct MainURL {
    static let domain = "http://localhost:8080"
}

struct User: Codable {
    let id: Int
    let username: String
    let email: String
    let password: String
    let emailValidated: Bool
    let name: String
    let bio: String
    let profileImage: String
    
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
