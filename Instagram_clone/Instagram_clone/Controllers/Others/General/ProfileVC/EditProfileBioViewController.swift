
import UIKit

class EditProfileBioViewController: EditProfileNameViewController {

    private let bioTextView: UITextView = {
        let textView = UITextView()
        textView.autocapitalizationType = .none
        textView.font = UIFont.systemFont(ofSize: 18.0)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.frame.size.height = 30
        return textView
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray.withAlphaComponent(0.5)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bioTextView)
        view.addSubview(lineView)
        bioTextView.becomeFirstResponder()
        bioTextView.delegate = self
    }
    
    override func configureContents() {
        if value == "Bio" {
            bioTextView.text = ""
        } else {
            bioTextView.text = value
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navibarHeight = self.navigationController?.navigationBar.height ?? 0
        
        bioTextView.frame.origin.x = 10
        bioTextView.frame.origin.y = statusBarHeight + navibarHeight
        bioTextView.frame.size.width = view.width - 20
        
        lineView.frame = CGRect(x: 10, y: bioTextView.bottom, width: view.width - 20, height: 1)
    }
    
    override func didTapEditProfileNameDoneButton() {
        let bio = bioTextView.text ?? ""
        super.delegate?.changeProfileBio(bio, super.index)
        self.navigationController?.popViewController(animated: true)
    }


}

extension EditProfileBioViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.width, height: textView.contentSize.height)
        textView.sizeThatFits(size) // it gets to call 'viewDidLayoutSubviews()'!!
    }
}
