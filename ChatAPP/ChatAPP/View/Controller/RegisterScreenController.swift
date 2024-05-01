//
//  RegisterScreenController.swift
//  ChatAPP
//
//  Created by Nazrin on 17.04.24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreInternal
import GoogleSignIn

class RegisterScreenController: UIViewController {
    
    let database = Firestore.firestore()
    var adapter: LoginAdapter?
    
    @IBOutlet weak var customRegister: CustomLoginRegisterView! {
        didSet {
            customRegister.doUISettings()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adapter = LoginAdapter(controller: self)
        
        adapter?.success = { user in
            self.customRegister.emailTextField.text = user.email
            self.customRegister.passwordTextField.text = user.password

        }
        navigationItem.title = "Create account"
        
    }
    
    @IBAction func googleSignButtonAction(_ sender: Any) {
        adapter?.googleSign()
        
    }
    
    @IBAction func registerAction(_ sender: Any) {
        let email = customRegister.emailTextField.text ?? ""
        let password = customRegister.passwordTextField.text ?? ""
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error bas verdi registerde: \(error.localizedDescription)")
            }   else {
                self.addFirebase()
            }
        }
    }
    
    func addFirebase() {
        let email = customRegister.emailTextField.text ?? ""
        let password = customRegister.passwordTextField.text ?? ""
        let myDictionary: [String: Any] = ["email": email,
                                           "password": password ]
        database.collection("Users").addDocument(data: myDictionary)
    }
}
