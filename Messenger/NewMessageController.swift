//
//  NewMessageController.swift
//  Messenger
//
//  Created by Egor on 17.09.17.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {

    let cellId = "cellId"
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    }
    
    func fetchUser(){
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            //this method works like for in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                
                let user = User()
                user.id = snapshot.key
                //if properties don't exactly match up with the firebase dicionary keys, app will be crash
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                
                //this method works in background queue, so use main async
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        
        }, withCancel: nil)
    }
    
    func handleCancel(){
        dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count 
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
    
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profielImageUrl = user.profileImageUrl{
            cell.profileImageView.loadImageUsingCache(with: profielImageUrl)
        }
        
        return cell
    }
    
    var chatsController: ChatsViewController?
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            
            let user = self.users[indexPath.row]
            
            self.chatsController?.showChatControllerFor(user: user)
        }
    }
        
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 72
    }
    
}
