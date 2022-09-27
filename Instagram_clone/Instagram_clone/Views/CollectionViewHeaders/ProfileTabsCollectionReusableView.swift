
import UIKit

protocol ProfileTabsCollectionReusableViewDelegate {
    func configureLikeCells()
    func configurePostCells()
}

class ProfileTabsCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "ProfileTabsCollectionReusableView"
    
    var delegate: ProfileTabsCollectionReusableViewDelegate?
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
        button.clipsToBounds = true
        button.tintColor = .black
        return button
    }()
    
    private let postButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "person.crop.square"), for: .normal)
        button.clipsToBounds = true
        button.tintColor = .systemGray.withAlphaComponent(0.5)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(likeButton)
        addSubview(postButton)
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        postButton.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = 40
        let position: CGFloat = (self.width - size * 2) / 3
        likeButton.frame = CGRect(x: position, y: 0, width: size, height: size)
        postButton.frame = CGRect(x: self.width - position - 40, y: 0, width: size, height: size)
    }
    
    @objc func didTapLikeButton() {
        likeButton.tintColor = .black
        postButton.tintColor = .systemGray.withAlphaComponent(0.5)
        delegate?.configureLikeCells()
    }
    
    @objc func didTapPostButton() {
        postButton.tintColor = .black
        likeButton.tintColor = .systemGray.withAlphaComponent(0.5)
        delegate?.configurePostCells()
    }
}
