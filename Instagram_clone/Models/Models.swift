
import Foundation

struct MainURL {
    static let domain = "http://localhost:8080"
    // "http://localhost:8080"
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
    var dayString: String
}

struct Post: Codable {
    let id: Int
    let username: String
    let content: String
    let mentions: [String]
    let hashtags: [String]
    let tagPeople: [String]
    let location: String
    let dayString: String
    let likes: [String]
}

struct HashTag: Codable {
    let id: Int
    let name: String
}

struct Comment: Codable {
    let id: Int
    let content: String
    let username: String
    let likes: [String]
    let mentions: [String]
    let hashtags: [String]
    let dayString: String
    let postId: Int
}
