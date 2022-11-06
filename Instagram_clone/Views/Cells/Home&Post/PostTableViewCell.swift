
import UIKit

protocol PostTableViewCellDelegate {
    func didTapTagButton()
}

class PostTableViewCell: UITableViewCell {
    
    static let identifier = "PostTableViewCell"
    
    var delegate: PostTableViewCellDelegate?
    
    var tags: [String]?
    
    private var mentionTipViewIsHidden = true
    
    public let mainImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let mentionIconButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "mentionIcon"), for: .normal)
        button.tintColor = .black
        button.frame.size = CGSize(width: 30, height: 30)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(mainImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        mainImageView.frame = self.bounds
    }
    
    public func showEffect() {
        let imageView = UIImageView(image: UIImage(systemName: "heart"))
        imageView.tintColor = .systemPink
        self.contentView.addSubview(imageView)
        imageView.center = self.contentView.center
        imageView.frame.size = CGSize.zero
        
        UIView.animate(withDuration: 1.0) {
            imageView.frame = self.bounds
        } completion: { result in
            if result {
                DispatchQueue.main.async {
                    imageView.removeFromSuperview()
                }
            }
        }
    }
    
    public func configureMentionIconButton() {
        self.contentView.addSubview(mentionIconButton)
        mentionIconButton.addTarget(self, action: #selector(didTapMentionIconButton), for: .touchUpInside)
        mentionIconButton.frame.origin.x = 10
        mentionIconButton.frame.origin.y = self.height - 40
    }
    
    @objc func didTapMentionIconButton() {
        guard let hasTags = tags else {
            return
        }
        if mentionTipViewIsHidden == true {
            for i in 0..<hasTags.count {
                makeBottomTipView(text: hasTags[i], index: i)
            }
            mentionTipViewIsHidden = false
        } else {
            eliminateAllBottomTipViews()
            mentionTipViewIsHidden = true
        }
        
    }
    
    private func makeBottomTipView(text: String, index: Int) {
        let bottomTipView = BottomTipView(viewColor: .black, height: 30, text: text)
        let width = bottomTipView.configureLabel(text)
        self.addSubview(bottomTipView)
        bottomTipView.frame.size.width = width + 10
        bottomTipView.frame.size.height = 30
        bottomTipView.frame.origin.x = self.width - width - 20
        bottomTipView.frame.origin.y = self.height - (CGFloat)(40 * (index + 1))
        bottomTipView.addLabel()
    }
    
    private func eliminateAllBottomTipViews() {
        let subViews = self.subviews
        for sub in subViews {
            if sub is BottomTipView {
                sub.removeFromSuperview()
            }
        }
    }
    
    public func configureTagButton(){
        self.contentView.addSubview(mentionIconButton)
        mentionIconButton.addTarget(self, action: #selector(didTapTagButton), for: .touchUpInside)
        mentionIconButton.frame.size = CGSize(width: 50, height: 50)
        mentionIconButton.frame.origin.x = 10
        mentionIconButton.frame.origin.y = self.height - 60
    }
    
    @objc func didTapTagButton() {
        delegate?.didTapTagButton()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.mainImageView.image = nil
        self.mentionIconButton.removeFromSuperview()
        self.eliminateAllBottomTipViews()
    }
    
}
