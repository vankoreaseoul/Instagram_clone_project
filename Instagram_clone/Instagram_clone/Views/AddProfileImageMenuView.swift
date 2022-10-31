
import PhotosUI
import UIKit

class AddProfileImageMenuView: EditProfileImageMenuView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        reConfigureCellModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func reConfigureCellModel() {
        for _ in 0..<3 {
            super.data.remove(at: 0)
        }
        var model = super.data.first
        model?.title = "Add From Library"
        super.data.remove(at: 0)
        super.data.append(model!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        super.container.frame.size.height = super.cancelButton.frame.size.height
        super.container.frame.origin.y = self.height - super.cancelButton.height * 3
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
                super.delegate?.closeMenuSheet()
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
                })
            }
        }
    }
    
    
    
}
