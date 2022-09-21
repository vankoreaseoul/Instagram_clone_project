
import UIKit

class EditProfilTextView: UIView {

    public let title: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        return label
    }()
    
    public let textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.init(name: (textField.font?.fontName)!, size: 25.0)
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    public let explantaion1: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.init(name: (label.font?.fontName)!, size: 14.0)
        label.numberOfLines = 2
        return label
    }()
    
    public let explantaion2: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.init(name: (label.font?.fontName)!, size: 14.0)
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(title)
        addSubview(textField)
        addSubview(explantaion1)
        addSubview(explantaion2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.frame = CGRect(x: 30, y: 10, width: self.width - 60, height: 20)
        textField.frame = CGRect(x: 30, y: title.bottom, width: self.width - 60, height: 40)
        explantaion1.frame = CGRect(x: 30, y: textField.bottom + 10, width: self.width - 60, height: 50)
        explantaion2.frame = CGRect(x: 30, y: explantaion1.bottom + 10, width: self.width - 60, height: 20)
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textField.bounds.height + 1, width: textField.bounds.width, height: 1)
        bottomLine.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        
        textField.borderStyle = UITextField.BorderStyle.none
        textField.layer.addSublayer(bottomLine)
        
        textField.becomeFirstResponder()
    }
    
}
