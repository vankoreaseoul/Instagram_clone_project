
import Foundation

struct MainURL {
    static let domain = "http://localhost:8080"
    // "http://localhost:8080"
}

struct User: Codable, Hashable {
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
    var content: String
    var mentions: [String]
    var hashtags: [String]
    var tagPeople: [String]
    var location: String
    var dayString: String
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

struct Message: Codable {
    let id: Int
    let senderId: Int
    let recipientId: Int
    let content: String
    let dayString: String
    var postId: Int = 0
}
