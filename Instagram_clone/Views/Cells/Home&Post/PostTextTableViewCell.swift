
import UIKit

protocol PostTextTableViewCellDelegate {
    func resizeCell(_ indexpath: IndexPath)
    func didTapReadmoreButton(sender: UIButton)
    func didTapCommentsLabel(sender: UIButton)
}

class PostTextTableViewCell: UITableViewCell {
   
    var indexpath: IndexPath?
    
    private var contentLabelTopConstraint: NSLayoutConstraint?
    private var commentsButtonTopConstraint: NSLayoutConstraint?
    private var dayLabelTopConstraint: NSLayoutConstraint?
    private var dayLabelBottomConstraint: NSLayoutConstraint?

    static let identifier = "PostTextTableViewCell"
    
    var delegate: PostTextTableViewCellDelegate?
    
    private var isExpand = false // Read more
    
    private let likeLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let moreButton: UIButton = {
       let button = UIButton()
        button.setTitle("Read more", for: .normal)
        button.setTitleColor(.systemGray2, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let commentsButton: UIButton = {
       let button = UIButton()
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let dayLabel: UILabel = {
       let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentLabelTopConstraint = contentLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
        commentsButtonTopConstraint = commentsButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 10)
        dayLabelTopConstraint = dayLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 30)
        dayLabelBottomConstraint = dayLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bringSubviewToFront(moreButton)
    }
    
    public func configureLikeLabel(usernames: [String]) {
        if usernames.count != 0 {
            self.addSubview(likeLabel)
            self.assignLikeLabelFrame()
            let text1 = "Liked by "
            let text2 = " and "
            let text3 = ", "
            let boldAttribute = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .bold)
               ]
            let mutableAttributedString1 = NSMutableAttributedString.init(string: text1)
            let mutableAttributedString2 = NSMutableAttributedString.init(string: text2)
            let mutableAttributedString3 = NSMutableAttributedString.init(string: text3)
            
            let newString = NSMutableAttributedString()
            
            if usernames.count == 1 {
                let boldText = NSAttributedString(string: usernames.first!, attributes: boldAttribute)
                newString.append(mutableAttributedString1)
                newString.append(boldText)
            } else if usernames.count == 2 {
                let boldText1 = NSAttributedString(string: usernames.first!, attributes: boldAttribute)
                let boldText2 = NSAttributedString(string: usernames.last!, attributes: boldAttribute)
                newString.append(mutableAttributedString1)
                newString.append(boldText1)
                newString.append(mutableAttributedString2)
                newString.append(boldText2)
            } else if usernames.count == 3 {
                let boldText1 = NSAttributedString(string: usernames.first!, attributes: boldAttribute)
                let boldText2 = NSAttributedString(string: usernames[1], attributes: boldAttribute)
                let boldText3 = NSAttributedString(string: usernames.last!, attributes: boldAttribute)
                newString.append(mutableAttributedString1)
                newString.append(boldText1)
                newString.append(mutableAttributedString3)
                newString.append(boldText2)
                newString.append(mutableAttributedString2)
                newString.append(boldText3)
            } else {
                let boldText1 = NSAttributedString(string: usernames.first!, attributes: boldAttribute)
                let boldText2 = NSAttributedString(string: (usernames.count - 1).description + " others", attributes: boldAttribute)
                newString.append(mutableAttributedString1)
                newString.append(boldText1)
                newString.append(mutableAttributedString2)
                newString.append(boldText2)
            }
            
            self.likeLabel.attributedText = newString
        } else {
            if self.subviews.contains(likeLabel) {
                likeLabel.text = ""
                likeLabel.removeFromSuperview()
            }
        }
    }
    
    private func assignLikeLabelFrame() {
        likeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        likeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        likeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        likeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    public func configureContentLabel(username: String, content: String) {
        self.addSubview(contentLabel)
        assignContentLabelFrame()
        
        let mutableAttributedString = setMentionHashTagTextColor(" " + content)
        
        let boldAttribute = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .bold)
           ]
           let boldText = NSAttributedString(string: username, attributes: boldAttribute)
           let newString = NSMutableAttributedString()
           newString.append(boldText)
           newString.append(mutableAttributedString)
        self.contentLabel.attributedText = newString
        
        let newSize = self.contentLabel.sizeThatFits(CGSize(width: self.width - 20, height: self.height))
        
        if newSize.height >= 36 {
            self.contentLabel.numberOfLines = 2
            self.configureMoreButton()
        } else {
            self.contentLabel.frame.size = newSize
        }
    }
    
    private func assignContentLabelFrame() {
        contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        
        if self.subviews.contains(likeLabel) {
            contentLabelTopConstraint?.constant = 40
            contentLabelTopConstraint!.isActive = true
        } else {
            contentLabelTopConstraint?.constant = 10
            contentLabelTopConstraint!.isActive = true
        }
    }
    
    public func reassignContentLabelFrame() {
        assignContentLabelFrame()
        delegate?.resizeCell(indexpath!)
    }
    
    private func configureMoreButton() {
        self.addSubview(moreButton)
        moreButton.addTarget(self, action: #selector(didTapReadmoreButton), for: .touchUpInside)
        moreButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 0.0).isActive = true
        moreButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0).isActive = true
        moreButton.widthAnchor.constraint(equalToConstant: 65).isActive = true
        moreButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    public func configureCommentsButton(comments: [Comment]) {
        var text = ""
        let count = comments.count
        assignCommentsButtonFrame(count: count)
        
        if count == 1 {
            text = "View \(count) comment"
        } else if count > 1 {
            text = "View all \(count) comments"
        }
        commentsButton.setTitle(text, for: .normal)
    }
    
    private func assignCommentsButtonFrame(count: Int) {
        if count > 0 {
            self.addSubview(commentsButton)
            commentsButton.addTarget(self, action: #selector(didTapCommentsButton), for: .touchUpInside)
            
            commentsButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
            commentsButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            commentsButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
            
            if self.subviews.contains(moreButton) {
                commentsButtonTopConstraint?.constant = 30
            } else {
                commentsButtonTopConstraint?.constant = 10
            }
            
            commentsButtonTopConstraint?.isActive = true
            
            if self.subviews.contains(dayLabel) {
                if self.subviews.contains(moreButton) {
                    dayLabelTopConstraint?.constant = 90
                } else {
                    dayLabelTopConstraint?.constant = 70
                }
                dayLabelTopConstraint?.isActive = true
                dayLabelBottomConstraint?.isActive = true
                delegate?.resizeCell(indexpath!)
            }
        } else {
            commentsButton.removeFromSuperview()
        }
    }
    
    @IBAction func didTapCommentsButton(sender: UIButton) {
        delegate?.didTapCommentsLabel(sender: sender)
    }
    
    public func configureDayLabel(dayString: String) {
        self.addSubview(dayLabel)
        dayLabel.text = dayString
        assignDayLabelFrame()
    }
    
    public func assignDayLabelFrame() {
        dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        dayLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -260).isActive = true
        dayLabelBottomConstraint!.priority = .defaultHigh
        dayLabelBottomConstraint!.isActive = true
    
        setDayLabelTopConstraint()
    }
    
    public func setDayLabelTopConstraint() {
        if self.subviews.contains(moreButton) && self.subviews.contains(commentsButton) {
            dayLabelTopConstraint?.constant = 90
        } else if self.subviews.contains(moreButton) && !self.subviews.contains(commentsButton) {
            dayLabelTopConstraint?.constant = 50
        } else if !self.subviews.contains(moreButton) && self.subviews.contains(commentsButton) {
            dayLabelTopConstraint?.constant = 70
        } else if !self.subviews.contains(moreButton) && !self.subviews.contains(commentsButton) {
            dayLabelTopConstraint?.constant = 30
        }
        dayLabelTopConstraint?.isActive = true
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
    
    @IBAction func didTapReadmoreButton(sender: UIButton) {
        delegate?.didTapReadmoreButton(sender: sender)
    }

    public func showFullContent() {
        self.contentLabel.numberOfLines = 0
        let newSize = self.contentLabel.sizeThatFits(CGSize(width: self.width - 20, height: self.height))
        self.contentLabel.frame.size = newSize
        self.isExpand = true
        self.moreButton.removeFromSuperview()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        likeLabel.text = ""
        contentLabel.text = ""
        if self.subviews.contains(moreButton) {
            moreButton.removeFromSuperview()
        }
        if self.subviews.contains(commentsButton) {
            commentsButton.removeFromSuperview()
        }
        dayLabel.text = ""
        isExpand = false
        
    }
}
