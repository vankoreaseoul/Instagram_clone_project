
import UIKit

class PeopleTableViewCell: UITableViewCell {
    
    static let identifier = "PeopleTableViewCell"
    
    public let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
       let label = UILabel()
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(profileImageView)
        self.addSubview(usernameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        assignFrames()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func assignFrames() {
        let size = self.width / 7
        profileImageView.frame = CGRect(x: 30, y: (self.height - size) / 2, width: size, height: size)
        profileImageView.layer.cornerRadius = size / 2
        usernameLabel.frame = CGRect(x: profileImageView.right + 30, y: profileImageView.top, width: self.width - 30 - profileImageView.width - 30 - 30, height: profileImageView.height)
    }
    
    public func configureUsername(_ text: String) {
        usernameLabel.text = text
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        usernameLabel.text = nil
    }

}
