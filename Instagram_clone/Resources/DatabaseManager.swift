
import Foundation

class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let mainURL = MainURL.domain
    
    public func canCreateNewUser( user: User, completion: @escaping (String) -> Void ) {
        let username = user.getUsername()
        let email = user.getEmail()
        
        let url = MainURL.domain + "/user/check"
        var components = URLComponents(string: url)
        let queryUsername = URLQueryItem(name: "username", value: username)
        let queryEmail = URLQueryItem(name: "email", value: email)
        components?.queryItems = [queryUsername, queryEmail]

        let totalUrl = (components?.url)!
        
        let task = URLSession.shared.dataTask(with: totalUrl) {(data, response, error) in
            guard let data = data else { return }
            let result = String(data: data, encoding: .utf8)!
            completion(result)
        }

        task.resume()
    }
    
    public func insertUser( user: User, completion: @escaping (String) -> Void ) {
        let username = user.getUsername()
        let email = user.getEmail()
        let password = user.getPassword()
        
        let params = ["username": username, "email": email, "password": password]
        let requestBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        let urlString = MainURL.domain + "/user"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody
        
        let defaultSession = URLSession(configuration: .default)
        defaultSession.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            let result = String(data: data, encoding: .utf8)!
            completion(result)
        }.resume()
    }
    
    public func readUser( username: String?, email: String?, password: String, completion: @escaping (String) -> Void ) {
        var params = [String : Optional<String>]()
        
        if let hasUsername = username {
            params = ["username": hasUsername, "email": email, "password": password]
            
        } else if let hasEmail = email {
            params = ["username": username, "email": hasEmail, "password": password]
        }
        
        let requestBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        let urlString = MainURL.domain + "/user/signin"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody
        
        let defaultSession = URLSession(configuration: .default)
        defaultSession.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            let result = String(data: data, encoding: .utf8)!
            completion(result)
        }.resume()
    }
    
    public func readUser( username: String?, email: String?, completion: @escaping (User) -> Void ) {
        let url = MainURL.domain + "/user"
        var components = URLComponents(string: url)
        let queryUsername = URLQueryItem(name: "username", value: username)
        let queryEmail = URLQueryItem(name: "email", value: email)
        
        components?.queryItems = [queryUsername, queryEmail]

        let totalUrl = (components?.url)!
        
        let task = URLSession.shared.dataTask(with: totalUrl) {(data, response, error) in
            guard let data = data else { return }
            let user: User = try! JSONDecoder().decode(User.self, from: data)
            completion(user)
        }

        task.resume()
    }
    
    
}

