
import UIKit

protocol MentionHashTagSearchResultViewDelegate {
    func didSelectUserCell(_ user: User)
    func didSelectHashTagCell(_ hashTag: HashTag)
    func didTapEnrollHashTagButton()
}

class MentionHashTagSearchResultView: UIView {
    
    var index = 0 // 0: mention, 1: hashTag
    
    var delegate: MentionHashTagSearchResultViewDelegate?
    
    var data: [(String, String)]?
    
    let hashTagAttributes: [NSAttributedString.Key: Any] = [
          .font: UIFont.systemFont(ofSize: 20),
          .foregroundColor: UIColor.blue,
          .underlineStyle: NSUnderlineStyle.single.rawValue
      ]
    
    let mentionAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 20, weight: .bold),
          .foregroundColor: UIColor.black,
      ]
    
    private let enrollHashTagButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.isEnabled = false
        return button
    }()
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(PeopleTableViewCell.self, forCellReuseIdentifier: PeopleTableViewCell.identifier)
        tableView.backgroundColor = .lightGray.withAlphaComponent(0.5)
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(enrollHashTagButton)
        self.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        enrollHashTagButton.addTarget(self, action: #selector(showHashTagInputAlert), for: .touchUpInside)
    }
    
    @objc func showHashTagInputAlert() {
        delegate?.didTapEnrollHashTagButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = self.bounds
        enrollHashTagButton.frame = CGRect(x: 100, y: 90, width: self.width - 200, height: 50)
    }
    
    public func reloadTableView() {
        self.tableView.reloadData()
        enrollHashTagButton.isHidden = true
        enrollHashTagButton.isEnabled = false
        
        if index == 0 && data!.isEmpty {
            enrollHashTagButton.isHidden = false
            let attributeString = NSMutableAttributedString(
                    string: "No Data",
                    attributes: mentionAttributes
                 )
            enrollHashTagButton.setAttributedTitle(attributeString, for: .normal)
        }
        
        if index == 1 && data!.isEmpty {
            enrollHashTagButton.isHidden = false
            enrollHashTagButton.isEnabled = true
            let attributeString = NSMutableAttributedString(
                    string: "Enroll HashTag",
                    attributes: hashTagAttributes
                 )
            enrollHashTagButton.setAttributedTitle(attributeString, for: .normal)
            self.bringSubviewToFront(enrollHashTagButton)
        }
    }
}

extension MentionHashTagSearchResultView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PeopleTableViewCell.identifier, for: indexPath) as! PeopleTableViewCell
        guard let hasData = self.data else {
            return cell
        }
        cell.backgroundColor = .lightGray.withAlphaComponent(0)
        cell.configureUsername(hasData[indexPath.row].0)
        
        if self.index == 0 {
            cell.profileImageView.setProfileImage(username: hasData[indexPath.row].0)
        } else {
            cell.profileImageView.image = UIImage(named: "hashTag")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let hasData = self.data else {
            return
        }
        if self.index == 0 {
            let username = hasData[indexPath.row].0
            DatabaseManager.shared.readUser(username: username, email: nil) { user in
                self.delegate?.didSelectUserCell(user)
            }
        } else {
            let hashTagName = hasData[indexPath.row].0
            DatabaseManager.shared.readHashTag(hashTagName) { hashTag in
                self.delegate?.didSelectHashTagCell(hashTag)
            }
            
            
        }
        
    }
    
}
