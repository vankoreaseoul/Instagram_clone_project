
import UIKit

protocol UnfollowMenuViewDelegate {
    func didTapUnfollowButton(_ user: User, _ indexPath: IndexPath)
    func didTapCancelButton()
}

class UnfollowMenuView: EditProfileImageMenuView {
    
    class ZeroTopPaddingLabel: UILabel {
        private var padding = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 16.0, right: 16.0)

        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.inset(by: padding))
        }
        
        override var intrinsicContentSize: CGSize {
             var contentSize = super.intrinsicContentSize
             contentSize.height += padding.top + padding.bottom
             contentSize.width += padding.left + padding.right

             return contentSize
        }
    }
    
    var customedDelegate: UnfollowMenuViewDelegate?
    
    var user: User?
    
    var indexPath: IndexPath?
    
    override func configureCellModel() {
        super.data.append(EditProfileImageMenuCellModel(title: "Unfollow", handler: {
            self.didTapUnfollowButton()
        }))
    }
    
    private func didTapUnfollowButton() {
        customedDelegate?.didTapUnfollowButton(user!, indexPath!)
    }
    
    override func didTapCancelButton() {
        customedDelegate?.didTapCancelButton()
    }
    
    override func handleDismiss(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.window)
        
        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.frame.size.width, height: self.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                customedDelegate?.didTapCancelButton()
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
                })
            }
        }
    }
    
    override func configureMenuTableView() {
        super.configureMenuTableView()
        super.menuTableView.register(UnfollowConfirmHeaderTableReusableView.self, forHeaderFooterViewReuseIdentifier: UnfollowConfirmHeaderTableReusableView.identifier)
    }
    
    func makeNoticeText(username: String) -> NSMutableAttributedString {
        let boldAttribute = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: .bold)
        ]
        let regularAttribute = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: .light)
        ]
        let boldText = NSAttributedString(string: username, attributes: boldAttribute)
        let regularText = NSAttributedString(string: "If you change you mind, you'll have to request to follow ", attributes: regularAttribute)
        let regularText2 = NSAttributedString(string: " again.", attributes: regularAttribute)
        
        let newString = NSMutableAttributedString()
        newString.append(regularText)
        newString.append(boldText)
        newString.append(regularText2)
    
        return newString
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: UnfollowConfirmHeaderTableReusableView.identifier) as! UnfollowConfirmHeaderTableReusableView
        
        let username = user!.username
        let text = makeNoticeText(username: username)
        
        var defaultImage = UIImage(named: "profileImage2")!
        if !user!.profileImage.isEmpty {
            StorageManager.shared.download(user!.profileImage) { image in
                DispatchQueue.main.async {
                    defaultImage = image
                    header.configureContents(image: defaultImage, text: text)
                }
            }
        } else {
            header.configureContents(image: defaultImage, text: text)
        }
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return super.container.height * 0.35
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return super.container.height * 0.65
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let customizedLabel = ZeroTopPaddingLabel()
        customizedLabel.text = data[indexPath.row].title
        customizedLabel.font = UIFont.boldSystemFont(ofSize: 18)
        customizedLabel.textAlignment = .center
        customizedLabel.textColor = .systemRed
        cell.addSubview(customizedLabel)
        customizedLabel.frame = CGRect(x: 30, y: 5, width: cell.width - 60, height: cell.height - 10)
        return cell
    }
    
}
