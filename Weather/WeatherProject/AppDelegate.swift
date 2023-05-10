//
//  AppDelegate.swift
//  Weather
//
//  Created by Konstantin Lyashenko on 14.02.2023.
//

import UIKit

let primaryColor = UIColor(red: 227/255, green: 197/255, blue: 159/255, alpha: 1)
let secondaryColor = UIColor(red: 149/255, green: 192/255, blue: 187/255, alpha: 1)
let myTintColor = UIColor(red: 27/255, green: 67/255, blue: 72/255, alpha: 1)

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

