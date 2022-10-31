
import UIKit

protocol RemoveMenuViewDelegate {
    func didTapRemoveButton(_ user: User, _ indexPath: IndexPath)
    func didTapCancelButton()
}

class RemoveMenuView: UnfollowMenuView {
    
    var customedDelegate2: RemoveMenuViewDelegate?
    
    override func configureCellModel() {
        super.data.append(EditProfileImageMenuCellModel(title: "Remove", handler: {
            self.didTapRemoveButton()
        }))
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
                customedDelegate2?.didTapCancelButton()
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
                })
            }
        }
    }
    
    @objc override func didTapCancelButton() {
        customedDelegate2?.didTapCancelButton()
    }
    
    @objc func didTapRemoveButton() {
        customedDelegate2?.didTapRemoveButton(user!, indexPath!)
    }
    
    override func configureMenuTableView() {
        super.configureMenuTableView()
        super.menuTableView.register(RemoveConfirmHeaderTableReusableView.self, forHeaderFooterViewReuseIdentifier: RemoveConfirmHeaderTableReusableView.customedIdentifier)
    }
    
    override func makeNoticeText(username: String) -> NSMutableAttributedString {
        let boldAttribute = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.systemBlue
        ]
        let boldAttribute1 = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0, weight: .bold)
        ]
        let regularAttribute = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0, weight: .light)
        ]
        let boldText = NSAttributedString(string: username, attributes: boldAttribute1)
        let boldText1 = NSAttributedString(string: "Remove Followers?\n", attributes: boldAttribute)
        let regularText = NSAttributedString(string: "Instagram won't tell ", attributes: regularAttribute)
        let regularText2 = NSAttributedString(string: " they were removed from your followers.", attributes: regularAttribute)
        
        let newString = NSMutableAttributedString()
        newString.append(boldText1)
        newString.append(regularText)
        newString.append(boldText)
        newString.append(regularText2)
    
        return newString
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RemoveConfirmHeaderTableReusableView.customedIdentifier) as! RemoveConfirmHeaderTableReusableView
        
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

   

}
