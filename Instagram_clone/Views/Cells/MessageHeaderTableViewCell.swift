
import UIKit

class MessageHeaderTableViewCell: UITableViewCell {
    
    static let identifier = "MessageHeaderTableViewCell"
    
    private lazy var myFollowUserList = [User]()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let followPostInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let relationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let commonFollowLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
        setProfileImageConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    private func addSubViews() {
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(usernameLabel)
        addSubview(followPostInfoLabel)
        addSubview(relationLabel)
        addSubview(commonFollowLabel)
    }
    
    private func setProfileImageConstraint() {
        let size: CGFloat = 100
        profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        profileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.width/2 - size/2 + 20).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: size).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: size).isActive = true
    }
    
    private func setNameLabelConstraint() {
        let size = nameLabel.frame.size
        nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.width/2 - size.width/2 + 20).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
    
    private func setUsernameLabelConstraint() {
        let size = usernameLabel.frame.size
        if nameLabel.frame.size != .zero {
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        } else {
            usernameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 5).isActive = true
        }
        
        usernameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.width/2 - size.width/2 + 20).isActive = true
        usernameLabel.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
    
    private func setFollowPostInfoLabelConstraint() {
        let size = followPostInfoLabel.frame.size
        followPostInfoLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5).isActive = true
        followPostInfoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.width/2 - size.width/2 + 20).isActive = true
        followPostInfoLabel.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        followPostInfoLabel.heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
    
    private func setRelationLabelConstraint() {
        let size = relationLabel.frame.size
        relationLabel.topAnchor.constraint(equalTo: followPostInfoLabel.bottomAnchor, constant: 5).isActive = true
        relationLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.width/2 - size.width/2 + 20).isActive = true
        relationLabel.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        relationLabel.heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
    
    private func setCommonFollowLabelConstraint() {
        let size = commonFollowLabel.frame.size
        let relationSize = relationLabel.frame.size
        
        if relationSize != .zero {
            commonFollowLabel.topAnchor.constraint(equalTo: relationLabel.bottomAnchor, constant: 5).isActive = true
            if size != .zero {
                let bottomConstrint = commonFollowLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100)
                bottomConstrint.priority = .defaultHigh
                bottomConstrint.isActive = true
            } else {
                let bottomConstrint = relationLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100)
                bottomConstrint.priority = .defaultHigh
                bottomConstrint.isActive = true
            }
        } else {
            commonFollowLabel.topAnchor.constraint(equalTo: followPostInfoLabel.bottomAnchor, constant: 5).isActive = true
            if size != .zero {
                let bottomConstrint = commonFollowLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100)
                bottomConstrint.priority = .defaultHigh
                bottomConstrint.isActive = true
            } else {
                let bottomConstrint = followPostInfoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100)
                bottomConstrint.priority = .defaultHigh
                bottomConstrint.isActive = true
            }
        }
        
        commonFollowLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.width/2 - size.width/2 + 20).isActive = true
        commonFollowLabel.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        commonFollowLabel.heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
    
    public func configureLabels(_ name: String, _ username: String, _ userId: Int) {
        nameLabel.text = name
        nameLabel.sizeToFit()
        setNameLabelConstraint()
        
        usernameLabel.text = username + " · Instagram"
        usernameLabel.sizeToFit()
        setUsernameLabelConstraint()
        
        configureFollowPostInfoLabel(userId)
        followPostInfoLabel.sizeToFit()
        setFollowPostInfoLabelConstraint()
        
        configureRelationLabel(userId)
        relationLabel.sizeToFit()
        setRelationLabelConstraint()
        
        commonFollowLabel.sizeToFit()
        setCommonFollowLabelConstraint()
    }
    
    private func configureFollowPostInfoLabel(_ userId: Int) {
        var postNumber = ""
        let semaphore = DispatchSemaphore(value: 0)
        DatabaseManager.shared.readAllPostsByUserIdList([userId]) { posts in
            postNumber = posts.count.description
            semaphore.signal()
        }
        semaphore.wait()
        
        var followersNumber = ""
        DatabaseManager.shared.numberOfFollowers(myUserId: userId) { number in
            followersNumber = number
            semaphore.signal()
        }
        semaphore.wait()
        
        var followText = ""
        if followersNumber == "0" || followersNumber == "1" {
            followText = followersNumber + " follower"
        } else {
            followText = followersNumber + " followers"
        }
        var postText = ""
        if postNumber == "0" || postNumber == "1" {
            postText = postNumber + " post"
        } else {
            postText = postNumber + " posts"
        }
        followPostInfoLabel.text = followText + " · " + postText
    }
    
    private func configureRelationLabel(_ userId: Int) {
        var counterpartFollowList = [Int]()
        let semaphore = DispatchSemaphore(value: 0)
        DatabaseManager.shared.readFollowingList(myUserId: userId) { users in
            counterpartFollowList = users.map( { return $0.id } )
            semaphore.signal()
        }
        semaphore.wait()
        
        let myUserId = StorageManager.shared.callUserInfo()!.id
        var myFollowList = [Int]()
        DatabaseManager.shared.readFollowingList(myUserId: myUserId) { users in
            self.myFollowUserList = users
            myFollowList = users.map( { return $0.id } )
            semaphore.signal()
        }
        semaphore.wait()
        
        var text = ""
        if counterpartFollowList.contains(myUserId) && myFollowList.contains(userId) {
            text = "You follow each other on Instagram"
        } else if counterpartFollowList.contains(myUserId) && !myFollowList.contains(userId) {
            text = "Follows you"
        } else if !counterpartFollowList.contains(myUserId) && myFollowList.contains(userId) {
            text = "You follow"
        }
        relationLabel.text = text
        
        configureCommonFollowLabel(myFollowList, counterpartFollowList)
    }
    
    private func configureCommonFollowLabel(_ myFollowList: [Int], _ counterpartFollowList: [Int]) {
        var commonList = [String]()
        for userId in myFollowList {
            if counterpartFollowList.contains(userId) {
                for user in myFollowUserList {
                    if user.id == userId {
                        commonList.append(user.username)
                    }
                }
            }
        }
        
        let count = commonList.count
        var text = ""
        if count > 2 {
            text = "You both follow \(commonList.first!) and \(count - 1)others"
        } else if count == 2 {
            text = "You both follow \(commonList.first!) and \(commonList.last!)"
        } else if count == 1 {
            text = "You both follow \(commonList.first!)"
        }
        commonFollowLabel.text = text
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = nil
        nameLabel.text = ""
        usernameLabel.text = ""
        followPostInfoLabel.text = ""
        relationLabel.text = ""
        commonFollowLabel.text = ""
    }
}
