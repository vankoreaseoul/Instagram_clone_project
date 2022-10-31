
import UIKit

class PeopleTableViewCell: UITableViewCell {
    
    static let identifier = "PeopleTableViewCell"
    
    var isRemoved = false
    
    private let removeButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .systemGray.withAlphaComponent(0.5)
        button.isHidden = true
        return button
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureImageView()
        configureTextLabel()
        configureRemoveButton()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func configureImageView() {
        let size = self.width / 7
        imageView?.frame = CGRect(x: 30, y: (self.height - size) / 2, width: size, height: size)
        imageView?.layer.cornerRadius = size / 2
        imageView?.clipsToBounds = true
        imageView?.contentMode = .scaleAspectFill
    }
    
    private func configureTextLabel() {
        textLabel?.frame = CGRect(x: imageView!.right + 30, y: imageView!.top, width: self.width - 30 - imageView!.width - 30 - 30, height: imageView!.height)
    }
    
    private func configureRemoveButton() {
        self.addSubview(removeButton)
        removeButton.frame = CGRect(x: self.width - 50, y: (self.height - 20) / 2, width: 20, height: 20)
        removeButton.addTarget(self, action: #selector(didTapRemoveButton), for: .touchUpInside)
    }
    
    public func showRemoveButton() {
        removeButton.isHidden = false
    }
    
    @objc func didTapRemoveButton() {
        isRemoved = true
    }

}
