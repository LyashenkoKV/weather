//
//  SceneDelegate.swift
//  Weather
//
//  Created by Konstantin Lyashenko on 14.02.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var activityIndicator: UIActivityIndicatorView?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let viewController = ViewController()
        let window = UIWindow(windowScene: windowScene)
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.center = viewController.view.center
        activityIndicator?.hidesWhenStopped = true
        
        self.window = window
        window.addSubview(activityIndicator!)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        activityIndicator?.startAnimating()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        activityIndicator?.stopAnimating()
    }
}

