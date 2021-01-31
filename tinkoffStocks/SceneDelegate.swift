//
//  SceneDelegate.swift
//  tinkoffStocks
//
//  Created by Никита Казанцев on 30.01.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//
//        window?.windowScene = windowScene
//        window?.makeKeyAndVisible()
//
//        let viewController = ViewController()
//        let navViewController = UINavigationController(rootViewController: viewController)
//        window?.rootViewController = navViewController
        
        let tabBarController = UITabBarController()
        
        if #available(iOS 13.0, *) {
            tabBarController.overrideUserInterfaceStyle = .dark
            }
                
                let firstTabNavigationController = UINavigationController.init(rootViewController: ViewController())
                let secondTabNavigationControoller = UINavigationController.init(rootViewController: NewsViewController())

                
                tabBarController.viewControllers = [firstTabNavigationController, secondTabNavigationControoller]
                
                
                let item1 = UITabBarItem(title: "Home", image: UIImage(systemName: "briefcase"), tag: 0)
                let item2 = UITabBarItem(title: "Contest", image:  UIImage(systemName: "newspaper"), tag: 1)

                firstTabNavigationController.tabBarItem = item1
                secondTabNavigationControoller.tabBarItem = item2

                        
                UITabBar.appearance().tintColor = UIColor(red: 0/255.0, green: 146/255.0, blue: 248/255.0, alpha: 1.0)
                
                self.window?.rootViewController = tabBarController
                
                window?.makeKeyAndVisible()

    }
    
    

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
  
    
}

