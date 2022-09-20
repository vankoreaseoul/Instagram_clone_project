
import Foundation
import UIKit

class StorageManager {
    
    static let shared = StorageManager()
    private let mainURL = MainURL.domain
    
    // MARK: - Server Storage
    
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
    
    public func deleteImage(filename: String) {
        let urlString = MainURL.domain + "/delete_profile_info"
        let url = URL(string: urlString)
       
        let param = ["filename": filename]
        let requestBody = try! JSONSerialization.data(withJSONObject: param, options: [])
        
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody
        
        let defaultSession = URLSession(configuration: .default)
        defaultSession.dataTask(with: request) {(data, response, error) in
        
        }.resume()
    }
    
    public func uploadImage(paramName: String, fileName: String, image: UIImage) {
        let urlString = MainURL.domain + "/upload_profile_info"
        let url = URL(string: urlString)
        
        // Random String for seperating boundary. Each field is seperated by line looking like '--(boundary)'
        let boundary = UUID().uuidString
        let session = URLSession.shared
        
        // Create URLRequest
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        
        // Set Boundary and Content-type
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        // Start by '--(boundary)'
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        // Define Header - Should return Data type by encoding UTF8 after writing by String
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        // Define Header 2 - Should return Data type by encoding UTF8 after writing by String. Seperation is '\r\n'.
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        // Add Content
        data.append(image.pngData()!)
        
        // Set '--(boundary)--' at the end of all
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                    print(json)
                }
            }
        }).resume()
    }
    
    
        
    // MARK: - Device Storage
    
    public func saveAtDirectory(image: UIImage, imageName: String) {
        let data = image.pngData()!
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentsURL.appendingPathComponent("profile_image")
        
        if !FileManager.default.fileExists(atPath: directoryURL.path) {
            do{
                try FileManager.default.createDirectory(atPath: directoryURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                NSLog("Couldn't create document directory")
            }
        }
    
        let fileURL = directoryURL.appendingPathComponent(imageName + ".png")
        
        do {
            // Write to Directory
            try data.write(to: fileURL)
            
            // Store Path in UserDefaults
            UserDefaults.standard.set(fileURL, forKey: "background")
        } catch {
            print("Unable to Write Data to Directory (\(error))")
        }
    }
    
    public func uploadFromDirectory(_ filePath: URL) -> UIImage? {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let splitted_url = String((filePath.description.split(separator: "/", maxSplits: 2))[2])
        let fileURL = documentsURL.appendingPathComponent(splitted_url)
    
        do {
            //  Upload from Directory
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Unable to Upload Data from Directory (\(error))")
            return nil
        }
    }
    
    public func deleteAtDirectory(_ filePath: URL) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let splitted_url = String((filePath.description.split(separator: "/", maxSplits: 2))[2])
        let fileURL = documentsURL.appendingPathComponent(splitted_url)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                //  Delete At Directory
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                print("Unable to Delete Data from Directory (\(error))")
            }
        }
    }
    
    
    // MARK: - Device UserDefaults
    
    public func callUserInfo() -> User? {
        if let savedData = UserDefaults.standard.object(forKey: UserDefaults.UserDefaultsKeys.user.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let savedObject = try? decoder.decode(User.self, from: savedData) {
                return savedObject
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    public func callProfileImagePath() -> URL? {
        var profileImagePath: URL?
        
        if let savedData = UserDefaults.standard.string(forKey: "background") {
            profileImagePath = URL(string: savedData)!
        }
        
        return profileImagePath
    }
    
    
}
