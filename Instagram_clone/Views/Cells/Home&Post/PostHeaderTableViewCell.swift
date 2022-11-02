
import UIKit

protocol PostHeaderTableViewCellDelegate {
    func didTapMoreButton(_ sender: UIButton)
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
    
    private let usernameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    private let locationLabel: UILabel = {
       let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 15)
        return label
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
        self.addSubview(moreButton)
        self.addSubview(locationLabel)
    }
    
    private func assignFrames() {
        profileImage.frame = CGRect(x: 5, y: 5, width: 40, height: 40)
        moreButton.frame = CGRect(x: self.width - 30, y: 15, width: 20, height: 20)
        moreButton.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
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
        locationLabel.text = location
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = UIImage(named: "profileImage2")
        usernameLabel.text = ""
        locationLabel.text = ""
    }
    
}
