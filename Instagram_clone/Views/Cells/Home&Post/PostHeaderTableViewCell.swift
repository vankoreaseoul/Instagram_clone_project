
import UIKit

protocol PostHeaderTableViewCellDelegate {
    func didTapMoreButton(_ sender: UIButton)
    func didTapLocationButton()
}

class PostHeaderTableViewCell: UITableViewCell {
    
    var index = 0
    
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
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    public let locationLabel: UIButton = {
        let button = UIButton()
        let label = UILabel()
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .left
        button.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: button.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(lessThanOrEqualTo: button.trailingAnchor, constant: -10).isActive = true
        label.topAnchor.constraint(equalTo: button.topAnchor, constant: 5).isActive = true
        label.bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
        return button
    }()
    
    private let moreButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        label.textColor = .systemGray
        return label
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
        self.addSubview(timeLabel)
    }
    
    private func assignFrames() {
        if index == 0 {
            profileImage.frame = CGRect(x: 5, y: 5, width: 40, height: 40)
        } else if index == 1 {
            profileImage.frame = CGRect(x: 5, y: 10, width: 60, height: 60)
        } else if index == 2 {
            profileImage.frame = CGRect(x: 10, y: 15, width: 50, height: 50)
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func didTapMoreButton(_ sender: UIButton) {
        delegate?.didTapMoreButton(sender)
    }
    
    public func setUsernameAndLocation(username: String, location: String, time: String) {
        if index == 0 {
            if location.isEmpty {
                usernameLabel.frame = CGRect(x: 55, y: 15, width: 250, height: 20)
            } else {
                usernameLabel.frame = CGRect(x: 55, y: 5, width: 250, height: 20)
                locationLabel.frame = CGRect(x: 55, y: usernameLabel.bottom - 3, width: 250, height: 20)
            }
        } else if index == 1 {
            usernameLabel.frame = CGRect(x: 80, y: 15, width: 250, height: 20)
            locationLabel.frame = CGRect(x: 80, y: usernameLabel.bottom, width: 120, height: 20)
        } else if index == 2 {
            usernameLabel.frame = CGRect(x: 75, y: 30, width: 240, height: 20)
        }
       
        usernameLabel.text = username
        for subview in locationLabel.subviews {
            if let label = subview as? UILabel {
                label.text = location
            }
        }
        
        if index == 1 {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US")
            formatter.dateFormat = "dd-MMMM-yyyy"
            let strDate = formatter.string(from: Date())
            
            let day = String(time.split(separator: " ", omittingEmptySubsequences: true).first!)
            let hour = String(String(time.split(separator: " ", omittingEmptySubsequences: true).last!).dropLast(3))
            if day == strDate {
                timeLabel.text = hour
            } else {
                timeLabel.text = day
            }
            
            timeLabel.frame = CGRect(x: 210, y: locationLabel.top, width: 100, height: 20)
            timeLabel.sizeToFit()
            timeLabel.frame = CGRect(x: self.width - timeLabel.width - 10, y: locationLabel.top + 3, width: timeLabel.width, height: 20)
        }
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
