
import Foundation
import UIKit

class StorageManager {
    
    static let shared = StorageManager()
    private let mainURL = MainURL.domain
    
    public func download( _ pathString: String, completion: @escaping (UIImage) -> Void ) {
        let url = MainURL.domain + "/download_profile_info"
        var components = URLComponents(string: url)
        let queryPathString = URLQueryItem(name: "pathString", value: pathString)
        components?.queryItems = [queryPathString]
        
        let totalUrl = (components?.url)!
        
        let task = URLSession.shared.dataTask(with: totalUrl) {(data, response, error) in
            guard let hasData = data else { return }
            let image = UIImage(data: hasData)!
            completion(image)
        }
        
        task.resume()
    }
        
        
}
