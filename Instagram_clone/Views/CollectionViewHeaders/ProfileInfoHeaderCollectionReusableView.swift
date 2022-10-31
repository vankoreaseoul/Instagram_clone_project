
import UIKit

protocol ProfileInfoHeaderCollectionReusableViewDelegate: AnyObject {
    func profileHeaderDidTapProfileImageView(_ image: UIImage)
    func profileHeaderDidTapPostsButton()
    func profileHeaderDidTapFollowersButton()
    func profileHeaderDidTapFollowingButton()
    func profileHeaderDidTapEditProfileButton()
    func resetHeaderViewHeight()
}

class ProfileInfoHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "ProfileInfoHeaderCollectionReusableView"
    
    weak var delegate: ProfileInfoHeaderCollectionReusableViewDelegate?
    
    public let profilePhotoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "profileImage2"))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    public let postsButton: UIButton = {
        let button = UIButton()
        let totalString = "0\nPosts"        // add number on title
        let highlightedString = "Posts"
        let range = (totalString as NSString).range(of: highlightedString)
        let attributedString = NSMutableAttributedString(string:totalString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemGray, range: range)
        button.setAttributedTitle(attributedString, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    public let followersButton: UIButton = {
        let button = UIButton()
        let totalString = "0\nFollowers"        // add number on title
        let highlightedString = "Followers"
        let range = (totalString as NSString).range(of: highlightedString)
        let attributedString = NSMutableAttributedString(string:totalString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemGray, range: range)
        button.setAttributedTitle(attributedString, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    public let followingButton: UIButton = {
        let button = UIButton()
        let totalString = "0\nFollowing"        // add number on title
        let highlightedString = "Following"
        let range = (totalString as NSString).range(of: highlightedString)
        let attributedString = NSMutableAttributedString(string:totalString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemGray, range: range)
        button.setAttributedTitle(attributedString, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    public let editProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)  
        button.setTitleColor(.label, for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = CGColor.init(gray: 0.3, alpha: 0.3)
        return button
    }()
    
    public let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    public let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "Bio"
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addButtonActions()
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(profilePhotoImageView)
        addSubview(postsButton)
        addSubview(followersButton)
        addSubview(followingButton)
        addSubview(editProfileButton)
        addSubview(nameLabel)
        addSubview(bioLabel)
        
        configureName()
        configureBio()
    }
    
    private func addButtonActions() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImageView))
        self.profilePhotoImageView.addGestureRecognizer(gesture)
        self.profilePhotoImageView.isUserInteractionEnabled = true
        
        postsButton.addTarget(self, action: #selector(didTapPostsButton), for: .touchUpInside)
        followersButton.addTarget(self, action: #selector(didTapFollowersButton), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(didTapFollowingButton), for: .touchUpInside)
        editProfileButton.addTarget(self, action: #selector(didTapEditProfileButton), for: .touchUpInside)
    }
    
    @objc func didTapProfileImageView() {
        delegate?.profileHeaderDidTapProfileImageView(profilePhotoImageView.image!)
    }
    
    @objc func didTapPostsButton() {
        delegate?.profileHeaderDidTapPostsButton()
    }
    @objc func didTapFollowersButton() {
        delegate?.profileHeaderDidTapFollowersButton()
    }
    @objc func didTapFollowingButton() {
        delegate?.profileHeaderDidTapFollowingButton()
    }
    @objc func didTapEditProfileButton() {
        delegate?.profileHeaderDidTapEditProfileButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureProfileImage()
    }
    
    public func setNewImage(_ image: UIImage) {
        profilePhotoImageView.image = image
        profilePhotoImageView.contentMode = .scaleAspectFill
        
        let profilePhotoSize = width / 3.5
        profilePhotoImageView.frame = CGRect(x: 2, y: 0, width: profilePhotoSize, height: profilePhotoSize).integral
        profilePhotoImageView.layer.cornerRadius = profilePhotoSize/2.0
        
        let buttonHeight = profilePhotoSize
        let countButtonWidth = (width - 10 - profilePhotoSize)/3
       
        postsButton.frame = CGRect(x: profilePhotoImageView.right, y: 0, width: countButtonWidth, height: buttonHeight).integral
        followersButton.frame = CGRect(x: postsButton.right - 10, y: 0, width: countButtonWidth, height: buttonHeight).integral
        followingButton.frame = CGRect(x: followersButton.right + 5, y: 0, width: countButtonWidth, height: buttonHeight).integral
        editProfileButton.frame = CGRect(x: 10, y: height - 10 - buttonHeight/3, width: width - 20, height: buttonHeight/3).integral
        
        let nameLabelSize = nameLabel.sizeThatFits(frame.size)
        nameLabel.frame = CGRect(x: 10, y: profilePhotoImageView.bottom + 5, width: width - 20, height: nameLabelSize.height).integral
        
        if self.subviews.contains(nameLabel) {
            let bioLabelSize = bioLabel.sizeThatFits(frame.size)
            bioLabel.frame = CGRect(x: 10, y: nameLabel.bottom + 10, width: width - 20, height: bioLabelSize.height).integral
        } else {
            let bioLabelSize = bioLabel.sizeThatFits(frame.size)
            bioLabel.frame = CGRect(x: 10, y: profilePhotoImageView.bottom + 5, width: width - 20, height: bioLabelSize.height).integral
        }
        
        delegate?.resetHeaderViewHeight()
    }
    
    public func setDefaultImage() {
        profilePhotoImageView.image = UIImage(named: "profileImage2")
        profilePhotoImageView.contentMode = .scaleAspectFit
        profilePhotoImageView.layer.masksToBounds = true
        
        let profilePhotoSize = width / 3.5
        profilePhotoImageView.frame = CGRect(x: 2, y: 0, width: profilePhotoSize, height: profilePhotoSize).integral
        profilePhotoImageView.layer.cornerRadius = profilePhotoSize/2.0
        
        let buttonHeight = profilePhotoSize
        let countButtonWidth = (width - 10 - profilePhotoSize)/3
       
        postsButton.frame = CGRect(x: profilePhotoImageView.right, y: 0, width: countButtonWidth, height: buttonHeight).integral
        followersButton.frame = CGRect(x: postsButton.right - 10, y: 0, width: countButtonWidth, height: buttonHeight).integral
        followingButton.frame = CGRect(x: followersButton.right + 5, y: 0, width: countButtonWidth, height: buttonHeight).integral
        editProfileButton.frame = CGRect(x: 10, y: height - 10 - buttonHeight/3, width: width - 20, height: buttonHeight/3).integral
        
        let nameLabelSize = nameLabel.sizeThatFits(frame.size)
        nameLabel.frame = CGRect(x: 10, y: profilePhotoImageView.bottom, width: width - 20, height: nameLabelSize.height).integral
        
        if self.subviews.contains(nameLabel) {
            let bioLabelSize = bioLabel.sizeThatFits(frame.size)
            bioLabel.frame = CGRect(x: 10, y: nameLabel.bottom + 10, width: width - 20, height: bioLabelSize.height).integral
        } else {
            let bioLabelSize = bioLabel.sizeThatFits(frame.size)
            bioLabel.frame = CGRect(x: 10, y: profilePhotoImageView.bottom, width: width - 20, height: bioLabelSize.height).integral
        }
        
        delegate?.resetHeaderViewHeight()
    }
    
    public func configureProfileImage() {
        if let path = StorageManager.shared.callProfileImagePath() {
            let profileImage = StorageManager.shared.uploadFromDirectory(path)!
            setNewImage(profileImage)
        } else {
            setDefaultImage()
        }
    }
    
    public func configureName() {
        let user = StorageManager.shared.callUserInfo()!
        if !user.name.isEmpty {
            nameLabel.text = user.name
        } else {
            nameLabel.text = "Name"
        }
    }
    
    public func configureBio() {
        let user = StorageManager.shared.callUserInfo()!
        if !user.bio.isEmpty {
            bioLabel.text = user.bio
        } else {
            bioLabel.text = "Bio"
        }
    }
    
    public func configurePostsButtonTitle() {
        let myUserId = StorageManager.shared.callUserInfo()!.id
        DatabaseManager.shared.readAllPostsByUserIdList([myUserId]) { posts in
            let numberString = posts.count.description
            DispatchQueue.main.async {
                let oldTitle = self.postsButton.titleLabel?.text
                guard let hasOldTitle = oldTitle else {
                    return
                }
                let newTitle = hasOldTitle.prefix(0) + numberString + (oldTitle?.dropFirst(1))!
                let totalString = String(newTitle)
                let highlightedString = "Posts"
                let range = (totalString as NSString).range(of: highlightedString)
                let attributedString = NSMutableAttributedString(string:totalString)
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemGray, range: range)
                self.postsButton.setAttributedTitle(attributedString, for: .normal)
            }
        }
    }
    
    
    public func configureFollowingButtonTitle() {
        let myUserId = StorageManager.shared.callUserInfo()!.id
        DatabaseManager.shared.numberOfFollowing(myUserId: myUserId) { numberString in
            DispatchQueue.main.async {
                let oldTitle = self.followingButton.titleLabel?.text
                guard let hasOldTitle = oldTitle else {
                    return
                }
                let newTitle = hasOldTitle.prefix(0) + numberString + (oldTitle?.dropFirst(1))!
                let totalString = String(newTitle)
                let highlightedString = "Following"
                let range = (totalString as NSString).range(of: highlightedString)
                let attributedString = NSMutableAttributedString(string:totalString)
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemGray, range: range)
                self.followingButton.setAttributedTitle(attributedString, for: .normal)
            }
        }
    }
    
    public func configureFollowersButtonTitle() {
        let myUserId = StorageManager.shared.callUserInfo()!.id
        DatabaseManager.shared.numberOfFollowers(myUserId: myUserId) { numberString in
            DispatchQueue.main.async {
                let oldTitle = self.followersButton.titleLabel?.text
                guard let hasOldTitle = oldTitle else {
                    return
                }
                let newTitle = hasOldTitle.prefix(0) + numberString + (oldTitle?.dropFirst(1))!
                let totalString = String(newTitle)
                let highlightedString = "Followers"
                let range = (totalString as NSString).range(of: highlightedString)
                let attributedString = NSMutableAttributedString(string:totalString)
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemGray, range: range)
                self.followersButton.setAttributedTitle(attributedString, for: .normal)
            }
        }
    }
    
    
    
    
}
