import UIKit

protocol MyPhotoMessageTableViewCellDelegate {
    func didTapMyPostLink(_ post: Post)
}

class MyPhotoMessageTableViewCell: UITableViewCell {
    
    static let identifier = "MyPhotoMessageTableViewCell"
    
    private var post: Post?
    var delegate: MyPhotoMessageTableViewCellDelegate?
    
    private var constraintArray = [NSLayoutConstraint]()
    
    private let contentBackgroundView: UIView = {
       let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let photoView: UIImageView = {
       let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let timeLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .right
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        contentView.addSubview(contentBackgroundView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(photoView)
        contentView.addSubview(timeLabel)
    }
    
    private func configureLink() {
        let tab = UITapGestureRecognizer(target: self, action: #selector(didTapLink))
        photoView.addGestureRecognizer(tab)
    }
    
    @objc func didTapLink() {
        guard let hasPost = post else {
            return
        }
        delegate?.didTapMyPostLink(hasPost)
    }
    
    private func setConstraints(_ size: CGSize) {
        constraintArray.append(contentsOf: [
            photoView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            photoView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            photoView.widthAnchor.constraint(equalToConstant: 100),
            photoView.heightAnchor.constraint(equalToConstant: 100),
            contentLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            contentLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -120),
            contentLabel.widthAnchor.constraint(equalToConstant: size.width),
            contentLabel.heightAnchor.constraint(equalToConstant: size.height),
            contentBackgroundView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            contentBackgroundView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
        
        if size.width > 100 {
            constraintArray.append(contentBackgroundView.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor, constant: -10))
        } else {
            constraintArray.append(contentBackgroundView.leadingAnchor.constraint(equalTo: photoView.leadingAnchor, constant: -10))
        }
        
        let heightConstraint = contentBackgroundView.heightAnchor.constraint(equalToConstant: contentLabel.height + 110 + 30)
        heightConstraint.priority = .defaultHigh
        
        constraintArray.append(heightConstraint)
        constraintArray.append(contentsOf: [
            contentBackgroundView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: -55),
            timeLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: 50),
            timeLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        contentBackgroundView.layer.cornerRadius = 10
        timeLabel.adjustsFontSizeToFitWidth = true
        
        NSLayoutConstraint.activate(constraintArray)
    }
    
    public func configureCell(_ text: String, _ time: String, _ postId: Int)  {
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
        contentLabel.text = ""
        timeLabel.text = ""
        photoView.image = nil
        post = nil
        NSLayoutConstraint.deactivate(constraintArray)
        constraintArray.removeAll()
    }

}
