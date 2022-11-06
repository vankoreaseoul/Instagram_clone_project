
import UIKit

protocol CommentTableViewCellDelegate { // Use contentview!
    func didTapCommentLikeButton(sender: UIButton)
}

class CommentTableViewCell: UITableViewCell {
    
    static let identifier = "CommentTableViewCell"
    
    var delegate: CommentTableViewCellDelegate?
    
    private let deleteImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "trash")
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .red.withAlphaComponent(0)
        imageView.tintColor = .white
        imageView.frame.size = CGSize(width: 30, height: 30)
        imageView.isHidden = true
        return imageView
    }()
    
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
        self.backgroundColor = .red.withAlphaComponent(0.5)
        self.contentView.backgroundColor = .systemBackground
        addSubViews()
        
        setConstraints()
        addTargetOnButtons()
    }
    
    private func addSubViews() {
        self.addSubview(deleteImageView)
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(likeLabel)
        self.contentView.addSubview(likeButton)
    }
    
    private func setConstraints() {
        profileImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5.0).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.layer.cornerRadius = 25
        
        contentLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5.0).isActive = true
        contentLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant:-35.0).isActive = true
        contentLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 70.0).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -50.0).isActive = true
        
        likeButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15.0).isActive = true
        likeButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15.0).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant:-5.0).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 70.0).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -180.0).isActive = true
        
        likeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        likeLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant:-5.0).isActive = true
        likeLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 210.0).isActive = true
        likeLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -50.0).isActive = true
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
    
    public func setImage(_ MaxX: CGFloat) {
        let width = self.width - MaxX
        let height = self.height
        let center: CGPoint = CGPoint(x: MaxX + width / 2, y: height / 2)
        
        if center.x == 0 || width < 30 || MaxX == self.width {
            deleteImageView.isHidden = true
        } else {
            deleteImageView.isHidden = false
        }
        
        deleteImageView.center = center
        
    }
    
    public func deleteAll() {
        profileImageView.image = nil
        contentLabel.text = ""
        timeLabel.text = ""
        likeLabel.text = ""
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
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
