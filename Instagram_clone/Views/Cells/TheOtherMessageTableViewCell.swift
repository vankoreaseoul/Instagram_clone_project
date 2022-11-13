
import UIKit

class TheOtherMessageTableViewCell: UITableViewCell {
    
    static let identifier = "TheOtherMessageTableViewCell"
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
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
        contentView.addSubview(timeLabel)
    }
    
    private func setConstraints(_ size: CGSize) {
        constraintArray.append(contentsOf: [
            profileImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            profileImageView.widthAnchor.constraint(equalToConstant: 30),
            profileImageView.heightAnchor.constraint(equalToConstant: 30),
            
            contentLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 50),
            contentLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            contentLabel.widthAnchor.constraint(equalToConstant: size.width),
            contentLabel.heightAnchor.constraint(equalToConstant: size.height),
            
            contentBackgroundView.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 40),
            contentBackgroundView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            contentBackgroundView.trailingAnchor.constraint(equalTo: contentLabel.trailingAnchor, constant: 10)
        ])
        
        let heightConstraint = contentBackgroundView.heightAnchor.constraint(equalToConstant: contentLabel.height + 30)
        heightConstraint.priority = .defaultHigh
        constraintArray.append(heightConstraint)
        
        constraintArray.append(contentsOf: [
            contentBackgroundView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: size.width + 25),
            timeLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: 50),
            timeLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        contentBackgroundView.layer.cornerRadius = 10
        timeLabel.adjustsFontSizeToFitWidth = true
        
        NSLayoutConstraint.activate(constraintArray)
    }
    
    public func configureCell(_ user: User?, _ text: String, _ time: String)  {
        profileImageView.setProfileImage(username: user!.username)
        contentLabel.text = text
        let newSize = contentLabel.sizeThatFits(CGSize(width: 220, height: self.contentView.height))
        contentLabel.frame.size = newSize
        setConstraints(newSize)
        timeLabel.text = time
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        contentLabel.text = ""
        timeLabel.text = ""
        NSLayoutConstraint.deactivate(constraintArray)
        constraintArray.removeAll()
    }
}
