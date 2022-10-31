
import UIKit

protocol PostHeaderTableViewCellDelegate {
    func didTapMoreButton()
}

class PostHeaderTableViewCell: UITableViewCell {
    
    var delegate: PostHeaderTableViewCellDelegate?
    
    static let identifier = "PostHeaderTableViewCell"
    
    private let moreButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(moreButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureImageView()
        configureUsernameLabel()
        configureMoreButton()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func configureImageView() {
        imageView?.contentMode = .scaleAspectFill
        imageView?.clipsToBounds = true
        imageView?.frame = CGRect(x: 5, y: 5, width: 40, height: 40)
        imageView?.layer.cornerRadius = imageView!.width / 2
        imageView?.image = UIImage(named: "profileImage2")
    }

    private func configureUsernameLabel() {
        textLabel?.frame = CGRect(x: imageView!.right + 10, y: 15, width: 250, height: 20)
    }
    
    private func configureMoreButton() {
        self.addSubview(moreButton)
        moreButton.frame = CGRect(x: self.width - 30, y: 15, width: 20, height: 20)
        moreButton.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
    }
    
    public func setValue(_ image: UIImage?, _ username: String) {
        if let hasImage = image {
            imageView?.image = hasImage
        }
        textLabel?.text = username
    }
    
    @objc func didTapMoreButton() {
        delegate?.didTapMoreButton()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = UIImage(named: "profileImage2")
        textLabel?.text = ""
    }
    
}
