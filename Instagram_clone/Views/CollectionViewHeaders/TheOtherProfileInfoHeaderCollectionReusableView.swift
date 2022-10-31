
import UIKit

protocol TheOtherProfileInfoHeaderCollectionReusableViewDelegate {
    func didTapFollowButton(myUserId: Int, followingToUserId: Int)
}

class TheOtherProfileInfoHeaderCollectionReusableView: ProfileInfoHeaderCollectionReusableView {
    enum Result: String {
        case following = "0"
        case NotFollowingYet = "1"
    }
    
    var isFrameSet = false
    
    var selfDelegate: TheOtherProfileInfoHeaderCollectionReusableViewDelegate?
    
    private let followButton: UIButton = {
       let button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let messageButton: UIButton = {
       let button = UIButton()
        button.setTitle("Message", for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.borderWidth = 1.0
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.layer.cornerRadius = 8
        return button
    }()
    
    var user: User? 
    
    static let identifier2 = "TheOtherProfileInfoHeaderCollectionReusableView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        reFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func reFrame() {
        super.nameLabel.removeFromSuperview()
        super.editProfileButton.removeFromSuperview()
        super.postsButton.isEnabled = false
        super.followersButton.isEnabled = false
        super.followingButton.isEnabled = false
    }
    
    override func layoutSubviews() {
        if isFrameSet {
            return
        }
        
        super.layoutSubviews()
        reConfigureBio()
        
        configureFollowOrMessageButton()
        if self.subviews.contains(followButton) {
            self.configureFollowButton()
        }
        if self.subviews.contains(messageButton) {
            self.configureMessageButton()
        }
    }
    
    override func configureProfileImage() {
        guard let hasUser = self.user else {
            return setDefaultImage()
        }
        if hasUser.profileImage.isEmpty {
            return setDefaultImage()
        } else {
            setDefaultImage()
            StorageManager.shared.download(hasUser.profileImage) { image in
                DispatchQueue.main.async {
                    super.profilePhotoImageView.image = image
                }
            }
        }
    }
    
    override func setDefaultImage() {
        super.setDefaultImage()
        reFrameButtons()
        
    }
    
    private func reFrameButtons() {
        super.postsButton.frame.origin.y = -20
        super.followersButton.frame.origin.y = -20
        super.followingButton.frame.origin.y = -20
    }
    
    public func reConfigureBio() {
        super.bioLabel.text = self.user?.bio
    }
    
    private func configureFollowOrMessageButton() {
        let myUserId = StorageManager.shared.callUserInfo()!.id
        DatabaseManager.shared.checkIfFollowing(myUserId: myUserId, followToUserId: user!.id) { result in
            DispatchQueue.main.async {
                if result == Result.NotFollowingYet.rawValue {
                    self.addSubview(self.followButton)
                } else {
                    self.addSubview(self.messageButton)
                }
            }
        }
    }
    
    private func configureFollowButton() {
        self.followButton.frame = CGRect(x: super.postsButton.left + 10, y: super.postsButton.bottom - 25, width: self.width - super.postsButton.left - 22, height: 28)
        followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
        isFrameSet = true
    }
    
    @objc func didTapFollowButton() {
        let myUserId = StorageManager.shared.callUserInfo()!.id
        let followingToUserId = user!.id
        selfDelegate?.didTapFollowButton(myUserId: myUserId, followingToUserId: followingToUserId)
    }
    
    override func didTapProfileImageView() {
        guard let hasUser = self.user else {
            return
        }
        
        if hasUser.profileImage.isEmpty {
            return
        } else {
            delegate?.profileHeaderDidTapProfileImageView(super.profilePhotoImageView.image!)
        }
    }
    
    public func configureMessageButton() {
        if self.subviews.contains(followButton) {
            self.followButton.removeFromSuperview()
            self.addSubview(messageButton)
        }
        
        messageButton.frame =  CGRect(x: super.postsButton.left + 10, y: postsButton.bottom - 25, width: self.width - postsButton.left - 22, height: 28)
        messageButton.addTarget(self, action: #selector(didTapMessageButton), for: .touchUpInside)
        isFrameSet = true
    }
    
    override func configurePostsButtonTitle() {
        let userId = self.user!.id
        DatabaseManager.shared.readAllPostsByUserIdList([userId]) { posts in
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
    
    override func configureFollowingButtonTitle() {
        let userId = self.user!.id
        DatabaseManager.shared.numberOfFollowing(myUserId: userId) { numberString in
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
    
    override func configureFollowersButtonTitle() {
        let userId = self.user!.id
        DatabaseManager.shared.numberOfFollowers(myUserId: userId) { numberString in
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
    
    
    @objc func didTapMessageButton() {
        
    }
    
}
