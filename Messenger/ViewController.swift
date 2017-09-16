//
//  ViewController.swift
//  Messenger
//
//  Created by Egor on 16.09.17.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
 
    func handleLogout(){
        let loginController = LoginViewController()
        present(loginController, animated: true, completion: nil)
    }
}
