
import UIKit

class AllCommentsViewController: CommentViewController {
    
    var placeholder: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        super.disappearKeyboard()
    }
    
    override func addSubViews() {
        super.addSubViews()
        postButton.removeFromSuperview()
    }
    
    override func assignFrames() {
        super.assignFrames()
        textView.frame.size.width = super.textView.frame.size.width + 50
    }
    
    private func configureTextView() {
        let username = StorageManager.shared.callUserInfo()!.username
        placeholder = "Add a comment as \(username).."
        textView.text = placeholder
        textView.textColor = .lightGray
        textView.font = .systemFont(ofSize: 15)
        textView.returnKeyType = .done
    }
    
    private func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    private func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
    }
    
    override func didTapPostButton() {
        let content = textView.text!
        let username = StorageManager.shared.callUserInfo()!.username
        let likes = [String]()
        let dayString = Date().description
        let postId = self.postId!
        
        let comment = Comment(id: 0, content: content, username: username, likes: likes, mentions: self.mentions, hashtags: self.hashTags, dayString: dayString, postId: postId)
        
        DatabaseManager.shared.insertComment(comment: comment) { result in
            switch result {
            case Result.success.rawValue:
                DispatchQueue.main.async {
                    self.textView.resignFirstResponder()
                    self.textView.text = self.placeholder
                    self.textView.textColor = .lightGray
                }
                super.configureData()
            case Result.failure.rawValue:
                print("Fail")
            default:
                fatalError("Invalid value")
            }
        }
    }
    
    private func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            self.didTapPostButton()
        }
        
        return true
    }

}
