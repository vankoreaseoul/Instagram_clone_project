
import UIKit

protocol ProfileTabsCollectionReusableViewDelegate {
    func configurePostCells()
    func configureTagCells()
}

class ProfileTabsCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "ProfileTabsCollectionReusableView"
    
    var delegate: ProfileTabsCollectionReusableViewDelegate?
    
    private let postButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
        button.clipsToBounds = true
        button.tintColor = .black
        return button
    }()
    
    private let TagButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "person.crop.square"), for: .normal)
        button.clipsToBounds = true
        button.tintColor = .systemGray.withAlphaComponent(0.5)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(postButton)
        addSubview(TagButton)
        postButton.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
        TagButton.addTarget(self, action: #selector(didTapMentionButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = 40
        let position: CGFloat = (self.width - size * 2) / 3
        postButton.frame = CGRect(x: position, y: 0, width: size, height: size)
        TagButton.frame = CGRect(x: self.width - position - 40, y: 0, width: size, height: size)
    }
    
    @objc func didTapPostButton() {
        postButton.tintColor = .black
        TagButton.tintColor = .systemGray.withAlphaComponent(0.5)
        delegate?.configurePostCells()
    }
    
    @objc func didTapMentionButton() {
        TagButton.tintColor = .black
        postButton.tintColor = .systemGray.withAlphaComponent(0.5)
        delegate?.configureTagCells()
    }
}
