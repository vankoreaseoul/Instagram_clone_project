
import Foundation

class DatabaseManager {
    
    static let shared = DatabaseManager()
    private init() {}
    
    // MARK: - User
    
    public func canCreateNewUser( user: User, completion: @escaping (String) -> Void ) {
        let username = user.username
        let email = user.email
        
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
        let username = user.username
        let email = user.email
        let password = user.password
        let dayString = user.dayString
        
        let params = ["username": username, "email": email, "password": password, "dayString": dayString]
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
    
    public func readUserById( userId: Int, completion: @escaping (User) -> Void ) {
        let url = MainURL.domain + "/user/id"
        var components = URLComponents(string: url)
        let queryUserId = URLQueryItem(name: "userId", value: userId.description)
        
        components?.queryItems = [queryUserId]

        let totalUrl = (components?.url)!
        
        let task = URLSession.shared.dataTask(with: totalUrl) {(data, response, error) in
            guard let data = data else { return }
            let user: User = try! JSONDecoder().decode(User.self, from: data)
            completion(user)
        }

        task.resume()
    }
    
    public func updateUser( user: User, completion: @escaping (String) -> Void ) {
        let name = user.name
        let username = user.username
        let bio = user.bio
        let email = user.email
        let dayString = Date().description
        
        let params = ["name": name, "username": username, "bio": bio, "email": email, "dayString": dayString]
        let requestBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        let urlString = MainURL.domain + "/user"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody
        
        let defaultSession = URLSession(configuration: .default)
        defaultSession.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            let result = String(data: data, encoding: .utf8)!
            completion(result)
        }.resume()
    }
    
    public func searchUsers( username: String, completion: @escaping ([(String, String)]) -> Void ) {
        let url = MainURL.domain + "/user/search"
        var components = URLComponents(string: url)
        let queryUsername = URLQueryItem(name: "username", value: username)
        components?.queryItems = [queryUsername]

        let totalUrl = (components?.url)!
        
        let task = URLSession.shared.dataTask(with: totalUrl) {(data, response, error) in
            guard let data = data else { return }
            let users: [User] = try! JSONDecoder().decode([User].self, from: data)
            
            let results = users.map { ($0.username, $0.profileImage) }
            completion(results)
        }

        task.resume()
    }
    
    
    // MARK: - Post
    
    public func inserPost( post: Post, completion: @escaping (String) -> Void ) {
        let semaphore = DispatchSemaphore(value: 0)
        
        let content = post.content
        let username = post.username
        var userId = 0
        readUser(username: username, email: nil) { user in
            userId = user.id
            semaphore.signal()
        }
        semaphore.wait()
        
        let tagPeopleUsernameList = post.tagPeople
        var tagPeopleUserIdList = [Int]()
        for i in 0..<tagPeopleUsernameList.count {
            let postPersonUsername = tagPeopleUsernameList[i]
            readUser(username: postPersonUsername, email: nil) { user in
                let postPersonId = user.id
                tagPeopleUserIdList.append(postPersonId)
                semaphore.signal()
            }
            semaphore.wait()
        }
        
        let location = post.location
        let dayString = post.dayString
        let likes = post.likes
        
        let mentionUsernameList = post.mentions
        var mentionUserIdList = [Int]()
        for i in 0..<mentionUsernameList.count {
            let mentionUsername = mentionUsernameList[i]
            readUser(username: mentionUsername, email: nil) { user in
                let mentionUserId = user.id
                mentionUserIdList.append(mentionUserId)
                semaphore.signal()
            }
            semaphore.wait()
        }
        
        let hashTagNameList = post.hashtags
        var hashTagIdList = [Int]()
        for i in 0..<hashTagNameList.count {
            let hashTagName = hashTagNameList[i]
            readHashTag(hashTagName) { hashTag in
                let hashTagId = hashTag.id
                hashTagIdList.append(hashTagId)
                semaphore.signal()
            }
            semaphore.wait()
        }
        
        let params = ["content": content, "userId": userId, "tagPeopleUserIdList": tagPeopleUserIdList, "location": location, "dayString": dayString, "mentionUserIdList": mentionUserIdList, "hashTagIdList": hashTagIdList, "likes": likes] as [String : Any]
        let requestBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        let urlString = MainURL.domain + "/post"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody
        
        let defaultSession = URLSession(configuration: .default)
        defaultSession.dataTask(with: request) {(data, response, error) in
            guard let hasData = data else { return }
            let result = String(data: hasData, encoding: .utf8)!
            completion(result)
        }.resume()
    }
    
    public func deletePost( postId: Int, completion: @escaping (String) -> Void ) {
         let param = ["postId": postId]
         let requestBody = try! JSONSerialization.data(withJSONObject: param, options: [])
         
         let urlString = MainURL.domain + "/post"
         let url = URL(string: urlString)!
         var request = URLRequest(url: url)
         request.httpMethod = "DELETE"
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.httpBody = requestBody
         
         let defaultSession = URLSession(configuration: .default)
         defaultSession.dataTask(with: request) {(data, response, error) in
             guard let hasData = data else { return }
             let result = String(data: hasData, encoding: .utf8)!
             completion(result)
         }.resume()
    }
    
    public func updatePost( post: Post, completion: @escaping (Post) -> Void ) {
        let semaphore = DispatchSemaphore(value: 0)
        
        let id = post.id
        let content = post.content
        let username = post.username
        var userId = 0
        readUser(username: username, email: nil) { user in
            userId = user.id
            semaphore.signal()
        }
        semaphore.wait()
        
        let tagPeopleUsernameList = post.tagPeople
        var tagPeopleUserIdList = [Int]()
        for i in 0..<tagPeopleUsernameList.count {
            let postPersonUsername = tagPeopleUsernameList[i]
            readUser(username: postPersonUsername, email: nil) { user in
                let postPersonId = user.id
                tagPeopleUserIdList.append(postPersonId)
                semaphore.signal()
            }
            semaphore.wait()
        }
        
        let location = post.location
        let dayString = post.dayString
        let likes = post.likes
        
        let mentionUsernameList = post.mentions
        var mentionUserIdList = [Int]()
        for i in 0..<mentionUsernameList.count {
            let mentionUsername = mentionUsernameList[i]
            readUser(username: mentionUsername, email: nil) { user in
                let mentionUserId = user.id
                mentionUserIdList.append(mentionUserId)
                semaphore.signal()
            }
            semaphore.wait()
        }
        
        let hashTagNameList = post.hashtags
        var hashTagIdList = [Int]()
        for i in 0..<hashTagNameList.count {
            let hashTagName = hashTagNameList[i]
            readHashTag(hashTagName) { hashTag in
                let hashTagId = hashTag.id
                hashTagIdList.append(hashTagId)
                semaphore.signal()
            }
            semaphore.wait()
        }
        
        let params = ["id": id, "content": content, "userId": userId, "tagPeopleUserIdList": tagPeopleUserIdList, "location": location, "dayString": dayString, "mentionUserIdList": mentionUserIdList, "hashTagIdList": hashTagIdList, "likes": likes] as [String : Any]
        let requestBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        let urlString = MainURL.domain + "/post"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody
        
        let defaultSession = URLSession(configuration: .default)
        defaultSession.dataTask(with: request) {(data, response, error) in
            guard let hasData = data else { return }
            let post: Post = try! JSONDecoder().decode(Post.self, from: hasData)
            completion(post)
        }.resume()
    }
    
    public func readAllPostsByUserIdList( _ userIdList: [Int], completion: @escaping ([Post]) -> Void ) {
        let url = MainURL.domain + "/post"
        var components = URLComponents(string: url)
        let queryUserIdList = URLQueryItem(name: "userIdList", value: userIdList.description)
        components?.queryItems = [queryUserIdList]
        
        let totalUrl = (components?.url)!
   
        let task = URLSession.shared.dataTask(with: totalUrl) {(data, response, error) in
            guard let hasData = data else { return }
            let posts: [Post] = try! JSONDecoder().decode([Post].self, from: hasData)
            completion(posts)
        }

        task.resume()
    }
    
    public func readTaggedPostsByUserId( _ userId: Int, completion: @escaping ([Post]) -> Void ) {
        let url = MainURL.domain + "/post/tag"
        var components = URLComponents(string: url)
        let queryUserId = URLQueryItem(name: "userId", value: userId.description)
        components?.queryItems = [queryUserId]
        
        let totalUrl = (components?.url)!
   
        let task = URLSession.shared.dataTask(with: totalUrl) {(data, response, error) in
            guard let hasData = data else { return }
            let posts: [Post] = try! JSONDecoder().decode([Post].self, from: hasData)
            completion(posts)
        }

        task.resume()
    }
    
    public func readHashtagPosts( _ hashtagId: Int, completion: @escaping ([Post]) -> Void ) {
        let url = MainURL.domain + "/post/hashtag"
        var components = URLComponents(string: url)
        let queryHashtagId = URLQueryItem(name: "hashtagId", value: hashtagId.description)
        components?.queryItems = [queryHashtagId]
        
        let totalUrl = (components?.url)!
   
        let task = URLSession.shared.dataTask(with: totalUrl) {(data, response, error) in
            guard let hasData = data else { return }
            let posts: [Post] = try! JSONDecoder().decode([Post].self, from: hasData)
            completion(posts)
        }

        task.resume()
    }
    
    public func insertLike( postId: Int, userId: Int, completion: @escaping (Post) -> Void ) {
         let params = ["postId": postId, "userId": userId]
         let requestBody = try! JSONSerialization.data(withJSONObject: params, options: [])
         
         let urlString = MainURL.domain + "/post/likes"
         let url = URL(string: urlString)!
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.httpBody = requestBody
         
         let defaultSession = URLSession(configuration: .default)
         defaultSession.dataTask(with: request) {(data, response, error) in
             guard let hasData = data else { return }
             let post: Post = try! JSONDecoder().decode(Post.self, from: hasData)
             completion(post)
         }.resume()
    }
    
    public func deleteLike( postId: Int, userId: Int, completion: @escaping (Post) -> Void ) {
         let params = ["postId": postId, "userId": userId]
         let requestBody = try! JSONSerialization.data(withJSONObject: params, options: [])
         
         let urlString = MainURL.domain + "/post/likes"
         let url = URL(string: urlString)!
         var request = URLRequest(url: url)
         request.httpMethod = "DELETE"
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.httpBody = requestBody
         
         let defaultSession = URLSession(configuration: .default)
         defaultSession.dataTask(with: request) {(data, response, error) in
             guard let hasData = data else { return }
             let post: Post = try! JSONDecoder().decode(Post.self, from: hasData)
             completion(post)
         }.resume()
    }
    
    
    
    // MARK: - Follow
    public func insertFollowing( myUserId: Int, followToUserId: Int, completion: @escaping (String) -> Void ) {
       let myUserId = myUserId
        var followToUserIdList = [String]()
        followToUserIdList.append(followToUserId.description)
        
        let params = ["myUserId": myUserId, "followToUserIdList": followToUserIdList] as [String : Any]
        let requestBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        let urlString = MainURL.domain + "/following"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody
        
        let defaultSession = URLSession(configuration: .default)
        defaultSession.dataTask(with: request) {(data, response, error) in
            guard let hasData = data else { return }
            let result = String(data: hasData, encoding: .utf8)!
            completion(result)
        }.resume()
    }
    
    public func checkIfFollowing( myUserId: Int, followToUserId: Int, completion: @escaping (String) -> Void ) {
        let url = MainURL.domain + "/following/check"
        var components = URLComponents(string: url)
        let queryMyUserId = URLQueryItem(name: "myUserId", value: myUserId.description)
        let queryFollowToUserId = URLQueryItem(name: "followToUserId", value: followToUserId.description)
        components?.queryItems = [queryMyUserId, queryFollowToUserId]

        let totalUrl = (components?.url)!
        
        let task = URLSession.shared.dataTask(with: totalUrl) {(data, response, error) in
            guard let data = data else { return }
            let result = String(data: data, encoding: .utf8)!
            completion(result)
        }

        task.resume()
    }
    
    public func numberOfFollowing( myUserId: Int, completion: @escaping (String) -> Void ) {
        let url = MainURL.domain + "/following/following_number"
        var components = URLComponents(string: url)
        let queryMyUserId = URLQueryItem(name: "myUserId", value: myUserId.description)
        components?.queryItems = [queryMyUserId]

        let totalUrl = (components?.url)!
        
        let task = URLSession.shared.dataTask(with: totalUrl) {(data, response, error) in
            guard let data = data else { return }
            let result = String(data: data, encoding: .utf8)!
            completion(result)
        }

        task.resume()
    }
    
    public func numberOfFollowers( myUserId: Int, completion: @escaping (String) -> Void ) {
        let url = MainURL.domain + "/following/followers_number"
        var components = URLComponents(string: url)
        let queryMyUserId = URLQueryItem(name: "myUserId", value: myUserId.description)
        components?.queryItems = [queryMyUserId]

        let totalUrl = (components?.url)!
        
        let task = URLSession.shared.dataTask(with: totalUrl) {(data, response, error) in
            guard let data = data else { return }
            let result = String(data: data, encoding: .utf8)!
            completion(result)
        }

        task.resume()
    }
    
    public func readFollowingList( myUserId: Int, completion: @escaping ([User]) -> Void ) {
        let url = MainURL.domain + "/following/following_list"
        var components = URLComponents(string: url)
        let queryMyUserId = URLQueryItem(name: "myUserId", value: myUserId.description)
        components?.queryItems = [queryMyUserId]

        let totalUrl = (components?.url)!
        
        let task = URLSession.shared.dataTask(with: totalUrl) {(data, response, error) in
            guard let data = data else { return }
            let users: [User] = try! JSONDecoder().decode([User].self, from: data)
            completion(users)
        }

        task.resume()
    }
    
    public func readFollowersList( myUserId: Int, completion: @escaping ([User]) -> Void ) {
        let url = MainURL.domain + "/following/followers_list"
        var components = URLComponents(string: url)
        let queryMyUserId = URLQueryItem(name: "myUserId", value: myUserId.description)
        components?.queryItems = [queryMyUserId]

        let totalUrl = (components?.url)!
        
        let task = URLSession.shared.dataTask(with: totalUrl) {(data, response, error) in
            guard let data = data else { return }
            let users: [User] = try! JSONDecoder().decode([User].self, from: data)
            completion(users)
        }

        task.resume()
    }
    
    public func unfollowToUser(myUserId: Int, theOtherUserId: Int, completion: @escaping (String) -> Void) {
        let urlString = MainURL.domain + "/following"
        let url = URL(string: urlString)
       
        let params = ["myUserId": myUserId, "theOtherUserId": theOtherUserId]
        let requestBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody
        
        let defaultSession = URLSession(configuration: .default)
        defaultSession.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            let result = String(data: data, encoding: .utf8)!
            completion(result)
        }.resume()
    }
    
    public func removeFollower(myUserId: Int, theOtherUserId: Int, completion: @escaping (String) -> Void) {
        let urlString = MainURL.domain + "/following/follower"
        let url = URL(string: urlString)
       
        let params = ["myUserId": myUserId, "theOtherUserId": theOtherUserId]
        let requestBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody
        
        let defaultSession = URLSession(configuration: .default)
        defaultSession.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            let result = String(data: data, encoding: .utf8)!
            completion(result)
        }.resume()
    }
    
    
    // MARK: - HashTag
    public func searchHashTag(_ name: String, completion: @escaping ([HashTag]) -> Void) {
        let url = MainURL.domain + "/hashTag/search"
        var components = URLComponents(string: url)
        let queryName = URLQueryItem(name: "name", value: name)
        components?.queryItems = [queryName]

        let totalUrl = (components?.url)!
        
        let task = URLSession.shared.dataTask(with: totalUrl) {(data, response, error) in
            guard let data = data else { return }
            let hashTags: [HashTag] = try! JSONDecoder().decode([HashTag].self, from: data)
            completion(hashTags)
        }

        task.resume()
    }
    
    public func insertNewHashTag(_ name: String, completion: @escaping (String) -> Void) {
         let param = ["name": name]
         let requestBody = try! JSONSerialization.data(withJSONObject: param, options: [])
         
         let urlString = MainURL.domain + "/hashTag"
         let url = URL(string: urlString)!
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.httpBody = requestBody
         
         let defaultSession = URLSession(configuration: .default)
         defaultSession.dataTask(with: request) {(data, response, error) in
             guard let hasData = data else { return }
             let result = String(data: hasData, encoding: .utf8)!
             completion(result)
         }.resume()
    }
    
    public func readHashTag(_ name: String, completion: @escaping (HashTag) -> Void) {
        let url = MainURL.domain + "/hashTag"
        var components = URLComponents(string: url)
        let queryName = URLQueryItem(name: "name", value: name)
        components?.queryItems = [queryName]

        let totalUrl = (components?.url)!
        
        let task = URLSession.shared.dataTask(with: totalUrl) {(data, response, error) in
            guard let data = data else { return }
            let hashTag: HashTag = try! JSONDecoder().decode(HashTag.self, from: data)
            completion(hashTag)
        }

        task.resume()
    }
    
    
    // MARK: - Comment
    
    public func insertComment( comment: Comment, completion: @escaping (String) -> Void ) {
        let content = comment.content
        let username = comment.username
        let dayString = comment.dayString
        let postId = comment.postId
        let mentions = comment.mentions
        let hashtags = comment.hashtags
        
        let params = ["content": content, "username": username, "dayString": dayString, "postId": postId, "mentions": mentions, "hashtags": hashtags] as [String : Any]
         let requestBody = try! JSONSerialization.data(withJSONObject: params, options: [])
         
         let urlString = MainURL.domain + "/comment"
         let url = URL(string: urlString)!
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.httpBody = requestBody
         
         let defaultSession = URLSession(configuration: .default)
         defaultSession.dataTask(with: request) {(data, response, error) in
             guard let hasData = data else { return }
             let result = String(data: hasData, encoding: .utf8)!
             completion(result)
         }.resume()
    }
    
    public func deleteComment(commentId: Int, completion: @escaping (String) -> Void) {
        let urlString = MainURL.domain + "/comment"
        let url = URL(string: urlString)
       
        let params = ["commentId": commentId]
        let requestBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody
        
        let defaultSession = URLSession(configuration: .default)
        defaultSession.dataTask(with: request) {(data, response, error) in
            guard let hasData = data else { return }
            let result = String(data: hasData, encoding: .utf8)!
            completion(result)
        }.resume()
    }
    
    public func readAllComments( postId: Int, completion: @escaping ([Comment]) -> Void) {
        let url = MainURL.domain + "/comment"
        var components = URLComponents(string: url)
        let queryPostId = URLQueryItem(name: "postIdString", value: postId.description)
        components?.queryItems = [queryPostId]

        let totalUrl = (components?.url)!
        
        let task = URLSession.shared.dataTask(with: totalUrl) {(data, response, error) in
            guard let hasData = data else { return }
            let comments: [Comment] = try! JSONDecoder().decode([Comment].self, from: hasData)
            completion(comments)
        }

        task.resume()
    }
    
    public func insertLike( commentId: Int, username: String, completion: @escaping (Comment) -> Void ) {
        let params = ["commentId": commentId, "username": username] as [String : Any]
         let requestBody = try! JSONSerialization.data(withJSONObject: params, options: [])
         
         let urlString = MainURL.domain + "/comment/like"
         let url = URL(string: urlString)!
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.httpBody = requestBody
         
         let defaultSession = URLSession(configuration: .default)
         defaultSession.dataTask(with: request) {(data, response, error) in
             guard let hasData = data else { return }
             let comment: Comment = try! JSONDecoder().decode(Comment.self, from: hasData)
             completion(comment)
         }.resume()
    }
    
    public func deleteLike(commentId: Int, username: String, completion: @escaping (Comment) -> Void) {
        let urlString = MainURL.domain + "/comment/like"
        let url = URL(string: urlString)
       
        let params = ["commentId": commentId, "username": username] as [String : Any]
        let requestBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody
        
        let defaultSession = URLSession(configuration: .default)
        defaultSession.dataTask(with: request) {(data, response, error) in
            guard let hasData = data else { return }
            let comment: Comment = try! JSONDecoder().decode(Comment.self, from: hasData)
            completion(comment)
        }.resume()
    }
    
}

