
import UIKit

protocol PostActionTableViewCellDelegate {
    func didTapHeartButton()
    func didTapChatBubbleButton()
    func didTapPaperPlaneButton()
    func didTapBookMarkButton()
}

class PostActionTableViewCell: UITableViewCell {
    
    static let identifier = "PostActionTableViewCell"
    
    var delegate: PostActionTableViewCellDelegate?
    
    private let heartButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 23), forImageIn: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let chatBubbleButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "bubble.right"), for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 23), forImageIn: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let paperPlaneButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 23), forImageIn: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let bookMarkButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 23), forImageIn: .normal)
        button.tintColor = .black
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        addButtonTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        assignFrames()
    }

    private func addSubviews() {
        self.addSubview(heartButton)
        self.addSubview(chatBubbleButton)
        self.addSubview(paperPlaneButton)
        self.addSubview(bookMarkButton)
    }
    
    private func assignFrames() {
        heartButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        chatBubbleButton.frame = CGRect(x: heartButton.right + 5, y: 0, width: 40, height: 40)
        paperPlaneButton.frame = CGRect(x: chatBubbleButton.right + 5, y: 0, width: 40, height: 40)
        bookMarkButton.frame = CGRect(x: self.width - 40, y: 0, width: 40, height: 40)
    }
    
    private func addButtonTargets() {
        heartButton.addTarget(self, action: #selector(didTapHeartButton), for: .touchUpInside)
        chatBubbleButton.addTarget(self, action: #selector(didTapChatBubbleButton), for: .touchUpInside)
        paperPlaneButton.addTarget(self, action: #selector(didTapPaperPlaneButton), for: .touchUpInside)
        bookMarkButton.addTarget(self, action: #selector(didTapBookMarkButton), for: .touchUpInside)
    }
    
    @objc func didTapHeartButton() {
        delegate?.didTapHeartButton()
    }
    
    @objc func didTapChatBubbleButton() {
        delegate?.didTapChatBubbleButton()
    }
    
    @objc func didTapPaperPlaneButton() {
        delegate?.didTapPaperPlaneButton()
    }
    
    @objc func didTapBookMarkButton() {
        delegate?.didTapBookMarkButton()
    }
}
