//
//  ChatsViewController.swift
//  Messenger
//
//  Created by Egor on 11.09.17.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit
import Firebase

class ChatsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var messages: [Message]?
    
    var chats: [Chat] = [Chat]()
    
    private let cellId = "cellId"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Chats"
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
    
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        
        setupData()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        let newMessaeImage = UIImage(named: "new-message")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: newMessaeImage, style: .plain, target: self, action: #selector(handleNewMessage))
        
        checkIfUserIsLoggedIn()
        
        observeMessages()
    }
    
    func observeMessages(){
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:Any]{
                
                print(dictionary)
                let chat = Chat()
                chat.setValuesForKeys(dictionary)
                
                self.chats.append(chat)
                print(self.chats.count)
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
                
            }

        }, withCancel: nil)
    }
    
    func handleNewMessage(){
        let newMessageController = NewMessageController()
        newMessageController.chatsController = self
        let navConroller = UINavigationController(rootViewController: newMessageController)
        present(navConroller, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil{
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
           //fetchUserAndSetupNavBar()
        }
    }
    
    func fetchUserAndSetupNavBar(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            
            if let dicionary = snapshot.value as? [String: AnyObject]{
                self.navigationItem.title = dicionary["name"] as? String
            }
            
        }, withCancel: nil)
    }
    
    func handleLogout(){
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError.localizedDescription)
        }
        
        let loginController = LoginViewController()
        //loginController.chatsController = self
        present(loginController, animated: true, completion: nil)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chats.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCell
        
        let chat = chats[indexPath.item]
        
        cell.messageLabel.text = chat.text
        //if let message = messages?[indexPath.item]{
          //  cell.message = message
        //}
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        
        let chatLogController = ChatLogController(collectionViewLayout: layout)
        navigationController?.pushViewController(chatLogController, animated: true)
       
        //let controller = ChatLogController(collectionViewLayout: layout)
        //controller.friend = messages?[indexPath.item].friend
        
        //navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - Flow layout 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    
    func showChatControllerFor(user: User){
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
}
