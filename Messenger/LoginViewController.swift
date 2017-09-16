//
//  LoginViewController.swift
//  Messenger
//
//  Created by Egor on 15.09.17.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(r: 255, g: 204, b: 0, alpha: 1)
        button.setTitle("Register", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        return button
    }()
    
    
    //MARK: Register new user
    func handleRegister(){
        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if let err = error{
                print(err.localizedDescription)
                return
            }
            
            guard let uid = user?.uid else {return}
            
            //succesfully autheticated
            let ref = Database.database().reference(fromURL: "https://messenger-63741.firebaseio.com/")
            let userReference = ref.child("users").child(uid)
            
            let values = ["name": name, "email": email]
            
            userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                
                if let err = error{
                    print(err.localizedDescription)
                    return
                }
                
                
            })
            
        }
    }

    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 130, g: 130, b: 130, alpha: 0.5)
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 130, g: 130, b: 130, alpha: 0.5)
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        return tf
    }()
    

    
    let profielImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "firebase")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupLoginView()
        view.backgroundColor = UIColor(r: 0, g: 122, b: 255, alpha: 1)
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profielImageView)
        
        setupInputContainerView()
        setuploginRegisterButton()
        setupProfileImageView()
    }
    
    func setupProfileImageView(){
        profielImageView.anchor(nil, left: nil, bottom: inputsContainerView.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 12, rightConstant: 0, widthConstant: 150, heightConstant: 150)
        profielImageView.anchorCenterXToSuperview()

    }

    
    func setupInputContainerView(){
        inputsContainerView.anchorCenterSuperview()
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        // NAME
        nameTextField.anchor(inputsContainerView.topAnchor, left: inputsContainerView.leftAnchor, bottom: nil, right: inputsContainerView.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        //set height
        nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        nameSeparatorView.anchor(nameTextField.bottomAnchor, left: inputsContainerView.leftAnchor, bottom: nil, right: inputsContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        //EMAIL
        emailTextField.anchor(nameSeparatorView.bottomAnchor, left: inputsContainerView.leftAnchor, bottom: nil, right: inputsContainerView.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        //set height
        emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        emailSeparatorView.anchor(emailTextField.bottomAnchor, left: inputsContainerView.leftAnchor, bottom: nil, right: inputsContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        //PASSWORD
        passwordTextField.anchor(emailSeparatorView.bottomAnchor, left: inputsContainerView.leftAnchor, bottom: nil, right: inputsContainerView.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        //set height
        passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
    }
   
    func setuploginRegisterButton(){
        loginRegisterButton.anchor(inputsContainerView.bottomAnchor, left: inputsContainerView.leftAnchor, bottom: nil, right: inputsContainerView.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
    }
    
}

extension UIColor{
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: CGFloat(alpha))
    }
}
