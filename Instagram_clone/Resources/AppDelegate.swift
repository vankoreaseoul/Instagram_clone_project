//
//  AppDelegate.swift
//  Instagram_clone
//
//  Created by Heawon Seo on 04/09/2022.
//

import UIKit
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {
    
    var window: UIWindow?
    
    func resetApp() {
        window?.rootViewController?.dismiss(animated: true)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        GMSPlacesClient.provideAPIKey("xxxxxx")
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.children.first is FilmViewController {
            let filmVC = FilmViewController()
            
            let vc1 = FilmLibraryViewController()
            let vc2 = FilmPhotoViewController()
            let vc3 = FilmVideoViewController()
            
            vc1.title = "Library"
            vc2.title = "Photo"
            vc3.title = "Video"
            
            let naviVC1 = UINavigationController(rootViewController: vc1)
            let naviVC2 = UINavigationController(rootViewController: vc2)
            let naviVC3 = UINavigationController(rootViewController: vc3)
            
            filmVC.setViewControllers([naviVC1, naviVC2, naviVC3], animated: false)
            
            filmVC.modalPresentationStyle = .fullScreen
            tabBarController.present(filmVC, animated: true)
            return false
        }
        return true
    } // for pop up FilmViewController
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

