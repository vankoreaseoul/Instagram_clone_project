
import UIKit

protocol PostActionTableViewCellDelegate {
    func didTapHeartButton(_ sender: UIButton)
    func didTapChatBubbleButton(_ sender: UIButton)
    func didTapPaperPlaneButton(_ sender: UIButton)
    func didTapBookMarkButton(_ sender: UIButton)
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
    
    public func addSubViewsAndTargets() {
        addSubviews()
        addButtonTargets()
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
    
    public func changeLikeButtonToFullHeart() {
        self.heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    }
    
    public func changeLikeButtonToEmptyHeart() {
        self.heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    public func configureHeartButton(usernames: [String]) {
        guard let logedIn = StorageManager.shared.callUserInfo() else {
           return
        }
        let myUsername = logedIn.username
        if usernames.contains(myUsername) {
            changeLikeButtonToFullHeart()
        } else {
            changeLikeButtonToEmptyHeart()
        }
    }
    
    
    
    @IBAction func didTapHeartButton(_ sender: UIButton) {
        delegate?.didTapHeartButton(sender)
    }
    
    @IBAction func didTapChatBubbleButton(_ sender: UIButton) {
        delegate?.didTapChatBubbleButton(sender)
    }
    
    @IBAction func didTapPaperPlaneButton(_ sender: UIButton) {
        delegate?.didTapPaperPlaneButton(sender)
    }
    
    @IBAction func didTapBookMarkButton(_ sender: UIButton) {
        delegate?.didTapBookMarkButton(sender)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        changeLikeButtonToEmptyHeart()
    }
}
