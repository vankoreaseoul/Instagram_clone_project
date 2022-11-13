
import UIKit

protocol TheOtherPhotoMessageTableViewCellDelegate {
    func didTapPostLink(_ post: Post)
}

class TheOtherPhotoMessageTableViewCell: UITableViewCell {

    static let identifier = "TheOtherPhotoMessageTableViewCell"
    
    private var post: Post?
    var delegate: TheOtherPhotoMessageTableViewCellDelegate?
    
    private var constraintArray = [NSLayoutConstraint]()
    
    public let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        let size: CGFloat = 30
        imageView.frame.size = CGSize(width: size, height: size)
        imageView.layer.cornerRadius = size / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let contentBackgroundView: UIView = {
       let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
       let label = UILabel()
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let photoView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
        configureLink()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
    }
    
    private func addSubViews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(contentBackgroundView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(photoView)
        contentView.addSubview(timeLabel)
    }
    
    private func configureLink() {
        let tab = UITapGestureRecognizer(target: self, action: #selector(didTapPost))
        photoView.addGestureRecognizer(tab)
    }
    
    @objc func didTapPost() {
        guard let hasPost = post else {
            return
        }
        delegate?.didTapPostLink(hasPost)
    }
    
    private func setConstraints(_ size: CGSize) {
        constraintArray.append(contentsOf: [
            profileImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            profileImageView.widthAnchor.constraint(equalToConstant: 30),
            profileImageView.heightAnchor.constraint(equalToConstant: 30),
            
            photoView.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 50),
            photoView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            photoView.widthAnchor.constraint(equalToConstant: 100),
            photoView.heightAnchor.constraint(equalToConstant: 100),
            
            contentLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 50),
            contentLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -120),
            contentLabel.widthAnchor.constraint(equalToConstant: size.width),
            contentLabel.heightAnchor.constraint(equalToConstant: size.height),
            
            contentBackgroundView.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 40),
            contentBackgroundView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
        
        if size.width > 100 {
            constraintArray.append(contentBackgroundView.trailingAnchor.constraint(equalTo: contentLabel.trailingAnchor, constant: 10))
        } else {
            constraintArray.append(contentBackgroundView.trailingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: 10))
        }
        
        let heightConstraint = contentBackgroundView.heightAnchor.constraint(equalToConstant: contentLabel.height + 110 + 30)
        heightConstraint.priority = .defaultHigh
        constraintArray.append(heightConstraint)
        
        constraintArray.append(contentsOf: [
            contentBackgroundView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: 50),
            timeLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        if size.width > 100 {
            constraintArray.append(timeLabel.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: size.width + 25))
        } else {
            constraintArray.append(timeLabel.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: 100 + 25))
        }
        
        contentBackgroundView.layer.cornerRadius = 10
        timeLabel.adjustsFontSizeToFitWidth = true
        
        NSLayoutConstraint.activate(constraintArray)
    }
    
    public func configureCell(_ user: User?, _ text: String, _ time: String, _ postId: Int)  {
        profileImageView.setProfileImage(username: user!.username)
        contentLabel.text = text
        let newSize = contentLabel.sizeThatFits(CGSize(width: 220, height: self.contentView.height))
        contentLabel.frame.size = newSize
        setConstraints(newSize)
        timeLabel.text = time
        DatabaseManager.shared.readPostsByPostId(postId) { post in
            DispatchQueue.main.async {
                let username = post.username
                self.post = post
                self.photoView.setPostImage(username: username, postId: postId)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        contentLabel.text = ""
        timeLabel.text = ""
        photoView.image = nil
        post = nil
        NSLayoutConstraint.deactivate(constraintArray)
        constraintArray.removeAll()
    }
}
