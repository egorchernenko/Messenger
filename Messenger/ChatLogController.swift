//
//  ChatLogController.swift
//  Messenger
//
//  Created by Egor on 11.09.17.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate{
    
    private let cellId = "cellId"
    
    var user: User? {
        didSet{
            navigationItem.title = user?.name
        }
    }
    
    lazy var inputTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Message"
        textField.delegate = self
        return textField
    }()
    
    var friend: Friend? {
        didSet{
            navigationItem.title = friend?.name
            
            messages = friend?.messages?.allObjects as? [Message]
            
            messages = messages?.sorted{$0.date!.timeIntervalSince1970 < $1.date!.timeIntervalSince1970}
        }
    }
    
    var messages: [Message]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        setupInputComponents()
    }

    func setupInputComponents(){
        let containerView = UIView()
        
        view.addSubview(containerView)
        
        containerView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
    
        let sendButton = UIButton(type: .system)
        sendButton.setImage(UIImage(named: "sendMessage"), for: .normal)
        sendButton.tintColor = .black
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        sendButton.anchor(containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 30, heightConstant: 0)
        

        containerView.addSubview(inputTextField)
        
        inputTextField.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: sendButton.leftAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor = UIColor(white: 0.90, alpha: 1)
        containerView.addSubview(seperatorLineView)
        
        seperatorLineView.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
    }
    
    func handleSend(){
        
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        
        let toId = user!.id!
        let fromId = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        
        
        let values = ["text": inputTextField.text!, "toID": toId, "fromID": fromId, "timestamp": timestamp] as [String : Any]
        childRef.updateChildValues(values)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogMessageCell
        
        cell.messageTextView.text = messages?[indexPath.item].text
        
        
        if let message = messages?[indexPath.item], let messageText = message.text, let profileImageName = message.friend?.profileImageName{
            
            cell.profileImageView.image = UIImage(named: profileImageName)
            
            let size: CGSize = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)

            if !message.isSender{
                cell.messageTextView.frame = CGRect(x: 48 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                
                cell.textBubbleView.frame = CGRect(x: 48 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 16, height: estimatedFrame.height + 20 + 6)
                
                cell.profileImageView.isHidden = false
                
//                cell.textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
                cell.bubbleImageView.image = ChatLogMessageCell.grayBubleImage
                cell.bubbleImageView.tintColor = UIColor(white: 0.95, alpha: 1)
                cell.messageTextView.textColor = .black

            } else {
                
                cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 16 - 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                
                cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8 - 16 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 10, height: estimatedFrame.height + 20 + 6)
                
                cell.profileImageView.isHidden = true
                
//                cell.textBubbleView.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/55, alpha: 1)
                cell.bubbleImageView.image = ChatLogMessageCell.blueBableImage
                cell.bubbleImageView.tintColor = UIColor(red: 0, green: 137/255, blue: 249/55, alpha: 1)
                cell.messageTextView.textColor = .white
            }


        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let messageText = messages?[indexPath.item].text{
            let size: CGSize = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        return CGSize(width: view.frame.width, height: 100)
    }
    
    //indent from top (first cell)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 0, 0, 0)
    }
    
}

class ChatLogMessageCell: BaseCell{
    
    let messageTextView : UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.text = "Sample text"
        textView.backgroundColor = .clear
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    
    static let grayBubleImage = UIImage(named: "bubble_gray")?.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    static let blueBableImage = UIImage(named: "bubble_blue")?.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    
    let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ChatLogMessageCell.grayBubleImage
        imageView.tintColor = UIColor(white: 0.90, alpha: 1)
        return imageView
    }()
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .clear
        
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        
        profileImageView.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 0, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        
        textBubbleView.addSubview(bubbleImageView)
        bubbleImageView.anchor(textBubbleView.topAnchor, left: textBubbleView.leftAnchor, bottom: textBubbleView.bottomAnchor, right: textBubbleView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}
