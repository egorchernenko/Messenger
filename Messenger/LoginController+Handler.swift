//
//  LoginController+Handler.swift
//  Messenger
//
//  Created by Egor on 17.09.17.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit
import Firebase

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    func handleSelectProfileImageView(){
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            profielImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            
            if let profileImage = self.profielImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1){
                
                storageRef.putData(uploadData, metadata: nil, completion: { (metaData, error) in
                    
                    if let err = error{
                        print(err.localizedDescription)
                        return
                    }
                    
                    if let profileImageUrl = metaData?.downloadURL()?.absoluteString{
                        
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                        
                        self.registerUserIntoDataBase(with: uid, values: values)
    
   
                    }
                })
            }
        }
    }

                                                                           //AnyObject
    private func registerUserIntoDataBase(with uid: String, values: [String: Any]){
        let ref = Database.database().reference(fromURL: "https://messenger-63741.firebaseio.com/")
        let userReference = ref.child("users").child(uid)
        
        
        userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
            
            if let err = error{
                print(err.localizedDescription)
                return
            }
            
            //self.chatsController?.fetchUserAndSetupNavBar() to avoid excess call firebase
            //self.chatsController?.navigationItem.title = values["name"] as? String
            
            self.dismiss(animated: true, completion: nil)
            print("Register succesfully")
            
        })
    }
}
