
import Foundation

class MailManager {
    static let shared = MailManager()
    private let mainURL = MainURL.domain
    
    public func sendEmail( email: String, completion: @escaping (String) -> Void ) {
        let url = MainURL.domain + "/mail/validEmail"
        var components = URLComponents(string: url)
        let queryEmail = URLQueryItem(name: "email", value: email)
        components?.queryItems = [queryEmail]

        let totalUrl = (components?.url)!
        
        let task = URLSession.shared.dataTask(with: totalUrl) {(data, response, error) in
            guard let data = data else { return }
            let result = String(data: data, encoding: .utf8)!
            completion(result)
        }
        
        task.resume()
    }
 
    public func sendCode( email: String, code: String, completion: @escaping (String) -> Void ) {
        
        let param = ["email": email, "code": code]
        let requestBody = try! JSONSerialization.data(withJSONObject: param, options: [])
        
        let urlString = MainURL.domain + "/mail/validEmail"
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
}
