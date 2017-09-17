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
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()
    
    func handleLoginRegister(){
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin(){
        guard let email = emailTextField.text, let password = passwordTextField.text else {return}

        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let err = error{
                print(err.localizedDescription)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
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
                
                self.dismiss(animated: true, completion: nil)
                print("Register succesfully")
                
            })
            
        }
    }

    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.spellCheckingType = .no
        tf.autocorrectionType = .no
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
        tf.spellCheckingType = .no
        tf.autocorrectionType = .no
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
        tf.spellCheckingType = .no
        tf.autocorrectionType = .no
        return tf
    }()
    
    let profielImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "firebase")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login","Register"])
        sc.tintColor = .white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    func handleLoginRegisterChange(){
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        //hide name text field
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100: 150
        
        //change height
        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? true : false
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 0, g: 122, b: 255, alpha: 1)
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profielImageView)
        view.addSubview(loginRegisterSegmentedControl)
        
        setupInputContainerView()
        setuploginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
    }
    
    func setupLoginRegisterSegmentedControl(){
        loginRegisterSegmentedControl.anchor(nil, left: inputsContainerView.leftAnchor, bottom: inputsContainerView.topAnchor, right: inputsContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 8, rightConstant: 0, widthConstant: 0, heightConstant: 36)
        loginRegisterSegmentedControl.anchorCenterXToSuperview()
    }
    
    func setupProfileImageView(){
        profielImageView.anchor(nil, left: nil, bottom: loginRegisterSegmentedControl.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 12, rightConstant: 0, widthConstant: 150, heightConstant: 150)
        profielImageView.anchorCenterXToSuperview()

    }

    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupInputContainerView(){
        inputsContainerView.anchorCenterSuperview()
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        // NAME
        nameTextField.anchor(inputsContainerView.topAnchor, left: inputsContainerView.leftAnchor, bottom: nil, right: inputsContainerView.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        //set height
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        nameSeparatorView.anchor(nameTextField.bottomAnchor, left: inputsContainerView.leftAnchor, bottom: nil, right: inputsContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        //EMAIL
        emailTextField.anchor(nameSeparatorView.bottomAnchor, left: inputsContainerView.leftAnchor, bottom: nil, right: inputsContainerView.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        //set height
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        
        emailSeparatorView.anchor(emailTextField.bottomAnchor, left: inputsContainerView.leftAnchor, bottom: nil, right: inputsContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        //PASSWORD
        passwordTextField.anchor(emailSeparatorView.bottomAnchor, left: inputsContainerView.leftAnchor, bottom: nil, right: inputsContainerView.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        //set height
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
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
