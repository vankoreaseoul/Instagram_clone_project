
import UIKit

protocol ProfileInfoHeaderCollectionReusableViewDelegate: AnyObject {
    func profileHeaderDidTapProfileImageView()
    func profileHeaderDidTapPostsButton()
    func profileHeaderDidTapFollowersButton()
    func profileHeaderDidTapFollowingButton()
    func profileHeaderDidTapEditProfileButton()
}

class ProfileInfoHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "ProfileInfoHeaderCollectionReusableView"
    
    weak var delegate: ProfileInfoHeaderCollectionReusableViewDelegate?
    
    private let profilePhotoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "profileImage"))
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
    
    private let editProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)  // add number on title
        button.setTitleColor(.label, for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = CGColor.init(gray: 0.3, alpha: 0.3)
        return button
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "bio"
        label.textColor = .label
        label.numberOfLines = 0
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
        addSubview(bioLabel)
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
        
        let profilePhotoSize = width/3
        profilePhotoImageView.frame = CGRect(x: 5, y: 20, width: profilePhotoSize, height: profilePhotoSize).integral
        profilePhotoImageView.layer.cornerRadius = profilePhotoSize/2.0
        
        let buttonHeight = profilePhotoSize
        let countButtonWidth = (width - 10 - profilePhotoSize)/3
       
        postsButton.frame = CGRect(x: profilePhotoImageView.right, y: 15, width: countButtonWidth, height: buttonHeight).integral
        followersButton.frame = CGRect(x: postsButton.right, y: 15, width: countButtonWidth, height: buttonHeight).integral
        followingButton.frame = CGRect(x: followersButton.right, y: 15, width: countButtonWidth, height: buttonHeight).integral
        editProfileButton.frame = CGRect(x: 10, y: height - 10 - buttonHeight/3, width: width - 20, height: buttonHeight/3).integral
        
        let bioLabelSize = bioLabel.sizeThatFits(frame.size)
        bioLabel.frame = CGRect(x: 25, y: 5 + profilePhotoImageView.bottom, width: width - 10, height: bioLabelSize.height).integral
        
        configureProfileImage()
        configureBio()
    }
    
    private func configureProfileImage() {
        if let savedData = UserDefaults.standard.object(forKey: UserDefaults.UserDefaultsKeys.user.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let savedObject = try? decoder.decode(User.self, from: savedData) {
                if !savedObject.profileImage.isEmpty {
                    // set image
                    print(1)
                }
            }
        }
    }
    
    private func configureBio() {
        if let savedData = UserDefaults.standard.object(forKey: UserDefaults.UserDefaultsKeys.user.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let savedObject = try? decoder.decode(User.self, from: savedData) {
                if !savedObject.bio.isEmpty {
                    // set bio
                    print(1)
                }
            }
        }
    }
    
    
}
