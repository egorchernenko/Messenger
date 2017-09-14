//
//  FriendCell.swift
//  Messenger
//
//  Created by Egor on 11.09.17.
//  Copyright © 2017 Egor. All rights reserved.
//

import Foundation
import UIKit

class MessageCell: BaseCell{
    
    //MARK: - Create UI elements

    var message: Message? {
        didSet{
            nameLabel.text = message?.friend?.name
            messageLabel.text = message?.text
            
            if let profileImageName = message?.friend?.profileImageName{
                profileImageView.image = UIImage(named: profileImageName)
                hasReadImageView.image = UIImage(named: profileImageName)
            }
            
            if let date = message?.date{
                
                let dateFromater = DateFormatter()
                dateFromater.dateFormat = "h:mm a"
                
                let elapsedTimeInSeconds = NSDate().timeIntervalSince(date as Date)
                
                let secondsInDays: TimeInterval = 60 * 60 * 24
                
                if elapsedTimeInSeconds > 7 * secondsInDays {
                    dateFromater.dateFormat = "MM/dd/yy"
                } else if elapsedTimeInSeconds > secondsInDays{
                    dateFromater.dateFormat = "EEE"
                }
                
                timeLabel.text = dateFromater.string(from: date as Date)
            }
            
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Friend Name"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Here you can see your friend's messageasdfsfasfsafsfsfasdfsdfsdfsad..."
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "12:05 pm"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    let hasReadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    //MARK: - Setup view
    
    override func setupView(){
        
        addSubview(profileImageView)
        addSubview(dividerLineView)
        
        setupContainerView()
        
        profileImageView.image = #imageLiteral(resourceName: "zuckerberg")
        hasReadImageView.image = #imageLiteral(resourceName: "zuckerberg")
        
        profileImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 68, heightConstant: 68)
        
        dividerLineView.anchor(nil, left: profileImageView.rightAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
    }
    
    //MARK: - Setup container
    
    private func setupContainerView(){
        let containerView = UIView()
        addSubview(containerView)

        containerView.anchor(self.topAnchor, left: profileImageView.rightAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 8, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(hasReadImageView)
        
        nameLabel.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        messageLabel.anchor(nameLabel.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: hasReadImageView.leftAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 28, widthConstant: 0, heightConstant: 0)
        
        timeLabel.anchor(containerView.topAnchor, left: nil, bottom: nil, right: containerView.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: 100, heightConstant: 0)
        
        hasReadImageView.anchor(nameLabel.bottomAnchor, left: nil, bottom: nil, right: containerView.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: 20, heightConstant: 20)
    }
    
    //MARK: - Custom highlited
    
    override var isHighlighted: Bool {
        didSet{
            backgroundColor = isHighlighted ? .lightGray : .white
        }
    }
    
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        backgroundColor = .blue
    }
}
