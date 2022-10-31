
import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate  // for pop up FilmViewController
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkSignin()
    }

    private func checkSignin() {
        let isSignedIn = UserDefaults.standard.isSignedIn()
        if isSignedIn == false {
            let signinVC = SignInViewController()
            signinVC.modalPresentationStyle = .fullScreen
            self.present(signinVC, animated: true)
        }
    }
    

}
