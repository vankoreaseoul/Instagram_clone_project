
import UIKit

class TextLabelCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TextLabelCollectionViewCell"
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor?.withAlphaComponent(0)
        self.isUserInteractionEnabled = true
        addSubview(textLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = self.bounds
    }
    
    public func configureTextLabel(_ text: String) {
        textLabel.text = text
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel.text = ""
    }
    
}
