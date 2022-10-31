
import UIKit

protocol CommentTableViewCellDelegate {
    func didTapCommentLikeButton(sender: UIButton)
}

class CommentTableViewCell: UITableViewCell {
    
    static let identifier = "CommentTableViewCell"
    
    var delegate: CommentTableViewCellDelegate?
    
    private let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let contentLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likeLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likeButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
        
        setConstraints()
        addTargetOnButtons()
    }
    
    private func addSubViews() {
        self.addSubview(profileImageView)
        self.addSubview(contentLabel)
        self.addSubview(timeLabel)
        self.addSubview(likeLabel)
        self.addSubview(likeButton)
    }
    
    private func setConstraints() {
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.layer.cornerRadius = 25
        
        contentLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0).isActive = true
        contentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant:-35.0).isActive = true
        contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 70.0).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50.0).isActive = true
        
        likeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15.0).isActive = true
        likeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15.0).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant:-5.0).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 70.0).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -180.0).isActive = true
        
        likeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        likeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant:-5.0).isActive = true
        likeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 210.0).isActive = true
        likeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50.0).isActive = true
    }
    
    private func addTargetOnButtons() {
        self.likeButton.addTarget(self, action: #selector(didTapCommentLikeButton), for: .touchUpInside)
    }
    
    @IBAction func didTapCommentLikeButton(sender: UIButton) {
        delegate?.didTapCommentLikeButton(sender: sender)
    }
    
    public func setValues(username: String, content: String, dayString: String, likes: [String]) {
        profileImageView.setProfileImage(username: username)
        
        let mutableAttributedString = setMentionHashTagTextColor(" " + content)
        
        let boldAttribute = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .bold)
           ]
           let boldText = NSAttributedString(string: username, attributes: boldAttribute)
           let newString = NSMutableAttributedString()
           newString.append(boldText)
           newString.append(mutableAttributedString)
        self.contentLabel.attributedText = newString
        
        timeLabel.text = dayString
        
        var likeText = ""
        if likes.count == 1 {
            likeText = likes.count.description + " like"
        } else if likes.count > 1 {
            likeText = likes.count.description + " likes"
        }
        
        likeLabel.text = likeText
        
        let myUsername = StorageManager.shared.callUserInfo()!.username
        if likes.contains(myUsername) {
            changeLikeButtonToFill()
        }
    }
    
    public func changeLikeButtonToFill() {
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    }
    
    public func changeLikeButtonToEmpty() {
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    private func setMentionHashTagTextColor(_ mainText: String) -> NSMutableAttributedString {
        let rangeForAll = (mainText as NSString).range(of: mainText)
        let hashTagSubString = mainText.split(separator: "#", maxSplits: 1, omittingEmptySubsequences: false).last
        let hashTagString = "#" + String(hashTagSubString ?? "")
        let rangeForHashtag = (mainText as NSString).range(of: hashTagString)
        
        let mentionSubString = mainText.split(separator: "@", maxSplits: 1, omittingEmptySubsequences: false).last
        let mentionString = "@" + String(mentionSubString ?? "")
        let blueColorString = String(mentionString.split(separator: "#", maxSplits: 1, omittingEmptySubsequences: false).first ?? "")
        let rangeForMention = (mainText as NSString).range(of: blueColorString)

        let mutableAttributedString = NSMutableAttributedString.init(string: mainText)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black.withAlphaComponent(0.57), range: rangeForHashtag)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: rangeForMention)
        mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 15, weight: .regular), range: rangeForAll)
        return mutableAttributedString
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bringSubviewToFront(likeButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        contentLabel.text = ""
        timeLabel.text = ""
        likeLabel.text = ""
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }

}
