
import UIKit

protocol PostMenuViewDelegate {
    func showTabbar()
    func didTapDelegateButton(_ post: Post, _ indexpathRow: Int)
    func didTapEditButton(_ post: Post, _ indexpathRow: Int)
}

class PostMenuView: EditProfileImageMenuView {
    
    var customDelegate: PostMenuViewDelegate?
    var post: Post?
    var indexpathRow = 0
   
    override func layoutSubviews() {
        cancelButton.frame = CGRect(x: 20, y: self.height - (self.height * 0.3 * 0.2 * 2), width: self.width - 40, height: self.height * 0.3 * 0.25)
        container.frame = CGRect(x: 20, y: self.height - (self.height - cancelButton.top + cancelButton.height * 2 + 10), width: self.width - 40, height: cancelButton.height * 2)
        
        configureMenuTableView()
    }
    
    override func configureCellModel() {
        data.append(EditProfileImageMenuCellModel(title: "Delete", handler: {
            self.didTapDeleteButton()
        }))
        data.append(EditProfileImageMenuCellModel(title: "Edit", handler: {
            self.didTapEditButton()
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
                self.removeFromSuperview()
                customDelegate?.showTabbar()
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
                })
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].title
        cell.textLabel?.textAlignment = .center
        
        if indexPath.row == 0 {
            cell.textLabel?.textColor = .systemRed
            cell.selectionStyle = .none
        } else {
            cell.textLabel?.textColor = .black
        }
        return cell
    }
    
    private func didTapDeleteButton() {
        guard let hasPost = post else {
            return
        }
        customDelegate?.didTapDelegateButton(hasPost, indexpathRow)
        didTapCancelButton()
    }
    
    private func didTapEditButton() {
        guard let hasPost = post else {
            return
        }
        customDelegate?.didTapEditButton(hasPost, indexpathRow)
        didTapCancelButton()
    }
    
    override func didTapCancelButton() {
        self.removeFromSuperview()
        customDelegate?.showTabbar()
    }
}
