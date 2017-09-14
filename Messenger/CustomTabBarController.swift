//
//  CustomTabBarController.swift
//  Messenger
//
//  Created by Egor on 12.09.17.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let freindsViewController = FriendsViewController(collectionViewLayout: layout)
        let recentNavigationController = UINavigationController(rootViewController: freindsViewController)
        recentNavigationController.tabBarItem.title = "Chats"
        recentNavigationController.tabBarItem.image = UIImage(named: "chats")
        
        let contactsViewController = UIViewController()
        let contactsNavigationController = UINavigationController(rootViewController: contactsViewController)
        contactsNavigationController.tabBarItem.title = "Contacts"
        contactsNavigationController.tabBarItem.image = UIImage(named: "contacts")
        
        let settingsViewController = UIViewController()
        let settingsNavigationViewController = UINavigationController(rootViewController: settingsViewController)
        settingsNavigationViewController.tabBarItem.title = "Settings"
        settingsNavigationViewController.tabBarItem.image = UIImage(named: "settings")
        
        viewControllers = [ recentNavigationController,contactsViewController, settingsViewController]
    }
    
}
