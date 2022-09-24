
import UIKit

protocol ProfileInfoHeaderCollectionReusableViewDelegate: AnyObject {
    func profileHeaderDidTapProfileImageView()
    func profileHeaderDidTapPostsButton()
    func profileHeaderDidTapFollowersButton()
    func profileHeaderDidTapFollowingButton()
    func profileHeaderDidTapEditProfileButton()
    func resetHeaderViewHeight()
}

class ProfileInfoHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "ProfileInfoHeaderCollectionReusableView"
    
    weak var delegate: ProfileInfoHeaderCollectionReusableViewDelegate?
    
    private let profilePhotoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "profileImage2"))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let postsButton: UIButton = {
        let button = UIButton()
        button.setTitle("0\nPosts", for: .normal)  // add number on title
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let followersButton: UIButton = {
        let button = UIButton()
        button.setTitle("0\nFollowers", for: .normal)  // add number on title
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let followingButton: UIButton = {
        let button = UIButton()
        button.setTitle("0\nFollowing", for: .normal)  // add number on title
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    public let editProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)  // add number on title
        button.setTitleColor(.label, for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = CGColor.init(gray: 0.3, alpha: 0.3)
        return button
    }()
    
    private let nameLabel: UILabel = {
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
        
        postsButton.addTarget(self, action: #selector(didTapPostsButton), for: .touchUpInside)
        followersButton.addTarget(self, action: #selector(didTapFollowersButton), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(didTapFollowingButton), for: .touchUpInside)
        editProfileButton.addTarget(self, action: #selector(didTapEditProfileButton), for: .touchUpInside)
    }
    
    @objc func didTapProfileImageView() {
        // show window where to be able to put gallary photo
        delegate?.profileHeaderDidTapProfileImageView()
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
    
    private func setNewImage(_ image: UIImage) {
        profilePhotoImageView.image = image
        
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
        
        let bioLabelSize = bioLabel.sizeThatFits(frame.size)
        bioLabel.frame = CGRect(x: 10, y: nameLabel.bottom + 10, width: width - 20, height: bioLabelSize.height).integral
        
        delegate?.resetHeaderViewHeight()
    }
    
    private func setDefaultImage() {
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
        
        let bioLabelSize = bioLabel.sizeThatFits(frame.size)
        bioLabel.frame = CGRect(x: 10, y: nameLabel.bottom + 10, width: width - 20, height: bioLabelSize.height).integral
        
        delegate?.resetHeaderViewHeight()
    }
    
    private func configureProfileImage() {
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
    
    
}
