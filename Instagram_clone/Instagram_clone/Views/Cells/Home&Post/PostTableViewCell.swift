
import UIKit

class PostTableViewCell: UITableViewCell {
    
    static let identifier = "PostTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.contentMode = .scaleToFill
        imageView?.clipsToBounds = true
        imageView?.frame = self.bounds
    }
    
    public func setImage(_ image: UIImage?) {
        if let hasImage = image {
            imageView?.image = hasImage
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
    }
    
    
}
