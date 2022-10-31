
import UIKit

class RemoveConfirmHeaderTableReusableView: UnfollowConfirmHeaderTableReusableView {
    
    static let customedIdentifier = "RemoveConfirmHeaderTableReusableView"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 30, y: self.height * 0.5, width: self.width - 60, height: self.height * 0.4)
    }

}
