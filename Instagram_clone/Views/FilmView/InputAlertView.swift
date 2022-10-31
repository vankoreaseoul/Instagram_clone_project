
import UIKit

protocol InputAlertViewDelegate {
    func didTapOKButton(_ text: String)
    func didTapCancelButton()
}

class InputAlertView: UIView {
    
    var delegate: InputAlertViewDelegate?
    
    private let customAlert: UIView = {
       let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private let message: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let textField: UITextField = {
       let textField = UITextField()
        textField.backgroundColor = .systemBackground
        textField.autocapitalizationType = .none
        textField.font = .systemFont(ofSize: 15)
        return textField
    }()
    
    private let resultLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    private let okButton: UIButton = {
       let button = UIButton()
        button.setTitle("OK", for: .normal)
        button.setTitleColor(.systemBlue.withAlphaComponent(0.3), for: .normal)
        button.isEnabled = false
        return button
    }()
    
    private let cancelButton: UIButton = {
       let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        return button
    }()
    
    private let line1: UIView = {
       let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    private let line2: UIView = {
       let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black.withAlphaComponent(0.2)
        addSubViews()
        addTargetOnButtons()
        addTargetOnTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        self.addSubview(customAlert)
        customAlert.addSubview(message)
        customAlert.addSubview(textField)
        customAlert.addSubview(resultLabel)
        customAlert.addSubview(line1)
        customAlert.addSubview(line2)
        customAlert.addSubview(okButton)
        customAlert.addSubview(cancelButton)
    }
    
    private func addTargetOnButtons() {
        okButton.addTarget(self, action: #selector(didTapOKButton), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
    }
    
    private func addTargetOnTextField() {
        self.textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    public func assignFrame(_ frame: CGRect) {
        self.frame = frame
        let customAlertWidth = self.width * 0.7
        customAlert.frame = CGRect(x: (self.width - customAlertWidth) / 2, y: self.height / 3.3, width: customAlertWidth, height: customAlertWidth * 0.6)
        customAlert.layer.cornerRadius = customAlertWidth * 0.05
        message.frame = CGRect(x: 20, y: 10, width: customAlertWidth - 40, height: 30)
        textField.frame = CGRect(x: 20, y: message.bottom + 15, width: customAlertWidth - 40, height: 30)
        resultLabel.frame = CGRect(x: 20, y: textField.bottom + 5, width: customAlertWidth - 40, height: 20)
        
        line1.frame = CGRect(x: 0, y: resultLabel.bottom + 10, width: customAlertWidth, height: 1)
        cancelButton.frame = CGRect(x: 0, y: customAlert.height - 40, width: customAlertWidth / 2, height: 40)
        okButton.frame =  CGRect(x: cancelButton.right, y: customAlert.height - 40, width: customAlertWidth / 2, height: 40)
        line2.frame = CGRect(x: cancelButton.right, y: line1.bottom, width: 1, height: customAlert.height - line1.bottom)
    }
    
    public func configureAlert(message: String, placeholder: String) {
        self.message.text = message
        self.textField.placeholder = placeholder
    }
    
    public func focusOnTextField() {
        self.textField.becomeFirstResponder()
    }
    
    public func clearTextField() {
        self.textField.text = ""
        self.resultLabel.text = ""
    }
    
    public func configureResultLabel(resultMessage: String, textColor: UIColor) {
        self.resultLabel.text = resultMessage
        self.resultLabel.textColor = textColor
    }
    
    @objc func textFieldChanged() {
        okButton.isEnabled = self.textField.text?.count ?? 0 > 0
        
        if okButton.isEnabled {
            okButton.setTitleColor(.systemBlue.withAlphaComponent(1.0), for: .normal)
        } else {
            okButton.setTitleColor(.systemBlue.withAlphaComponent(0.3), for: .normal)
        }
        
        if let hasText = resultLabel.text, !hasText.isEmpty {
            resultLabel.text = ""
        }
    }
    
    @objc func didTapOKButton() {
        let text = textField.text ?? ""
        delegate?.didTapOKButton(text)
    }
    
    @objc func didTapCancelButton() {
        delegate?.didTapCancelButton()
    }
    
}
