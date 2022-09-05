
import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // whether signed in or not
        checkSignin()
    }

    private func checkSignin() {
        // check session
        
        // show signin view
        let signinVC = SignInViewController()
        signinVC.modalPresentationStyle = .fullScreen
        self.present(signinVC, animated: true)
    }

}

