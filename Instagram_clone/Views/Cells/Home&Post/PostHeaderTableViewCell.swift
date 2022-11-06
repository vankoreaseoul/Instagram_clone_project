
import UIKit

protocol PostHeaderTableViewCellDelegate {
    func didTapMoreButton(_ sender: UIButton)
    func didTapLocationButton()
}

class PostHeaderTableViewCell: UITableViewCell {
    
    var delegate: PostHeaderTableViewCellDelegate?
    
    static let identifier = "PostHeaderTableViewCell"
    
    public let profileImage: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit 
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.width / 2
        imageView.image = UIImage(named: "profileImage2")
        return imageView
    }()
    
    public let usernameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    public let locationLabel: UIButton = {
       let button = UIButton()
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.titleLabel?.textAlignment = .left
        return button
    }()
    
    private let moreButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        assignFrames()
        self.bringSubviewToFront(moreButton)
    }
    
    private func addSubviews() {
        self.addSubview(profileImage)
        self.addSubview(usernameLabel)
        self.contentView.addSubview(locationLabel)
    }
    
    private func assignFrames() {
        profileImage.frame = CGRect(x: 5, y: 5, width: 40, height: 40)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func didTapMoreButton(_ sender: UIButton) {
        delegate?.didTapMoreButton(sender)
    }
    
    public func setUsernameAndLocation(username: String, location: String) {
        if location.isEmpty {
            usernameLabel.frame = CGRect(x: 55, y: 15, width: 250, height: 20)
        } else {
            usernameLabel.frame = CGRect(x: 55, y: 5, width: 250, height: 20)
            locationLabel.frame = CGRect(x: 55, y: usernameLabel.bottom - 3, width: 250, height: 20)
        }
        usernameLabel.text = username
        locationLabel.setTitle(location, for: .normal)
        locationLabel.sizeToFit()
    }
    
    public func configureMoreButton(_ username: String) {
        let myUsername = StorageManager.shared.callUserInfo()!.username
        if myUsername == username {
            self.addSubview(moreButton)
            moreButton.frame = CGRect(x: self.width - 30, y: 15, width: 20, height: 20)
            moreButton.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        }
    }
    
    public func addAction() {
        locationLabel.addTarget(self, action: #selector(didTapLocationButton), for: .touchUpInside)
    }
    
    @objc func didTapLocationButton() {
        delegate?.didTapLocationButton()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = UIImage(named: "profileImage2")
        usernameLabel.text = ""
        locationLabel.setTitle("", for: .normal)
        moreButton.removeFromSuperview()
    }
    
}
