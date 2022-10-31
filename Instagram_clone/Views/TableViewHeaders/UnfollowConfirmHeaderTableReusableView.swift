
import UIKit

class UnfollowConfirmHeaderTableReusableView: UITableViewHeaderFooterView {
    
    static let identifier = "UnfollowConfirmHeaderTableReusableView"
    
    let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let label: UILabel = {
      let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(imageView)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize = self.height * 0.6 * 0.9
        imageView.layer.cornerRadius = imageSize / 2
        imageView.frame = CGRect(x: (self.width - imageSize) / 2, y: (self.height * 0.6 - imageSize) / 2 - 10, width: imageSize, height: imageSize)
        label.frame = CGRect(x: 10, y: self.height * 0.57, width: self.width - 20, height: self.height * 0.4 - 7)
    }
    
    public func configureContents(image: UIImage, text: NSMutableAttributedString) {
        imageView.image = image
        label.attributedText = text
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        label.text = ""
    }

}
