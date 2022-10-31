
import UIKit
import Photos

class FilmViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tabBar.frame.size.height = 40
        self.tabBar.frame.origin.y = view.frame.height - tabBar.frame.size.height
    }
    
    private func configureTabBar() {
        let tabBarAppearance = UITabBarAppearance()
        let tabBarItemAppearance = UITabBarItemAppearance()
        
        tabBarAppearance.backgroundColor = .black
        
        tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.8)]
        tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0)]
        tabBarItemAppearance.normal.titlePositionAdjustment =  UIOffset(horizontal: 0, vertical: -10)
        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        
        self.tabBar.standardAppearance = tabBarAppearance
        self.tabBar.scrollEdgeAppearance = tabBarAppearance
    }
}


class CommonForm: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureNaviBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func configureNaviBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancelButton))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(didTapNextButton))
    }
    
    @objc func didTapCancelButton() {
        self.dismiss(animated: true)
    }
    
    @objc func didTapNextButton() {

    }

}


class FilmPhotoViewController: CommonForm {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class FilmVideoViewController: CommonForm {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
