//
//  RegisterScreenController.swift
//  ChatAPP
//
//  Created by Nazrin on 17.04.24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreInternal

class RegisterScreenController: UIViewController {
    
    let database = Firestore.firestore()

    @IBOutlet weak var customRegister: CustomLoginRegisterView! {
        didSet {
            customRegister.delegate = self
            customRegister.doUISettings()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create account"
    }
    
    @IBAction func registerAction(_ sender: Any) {
        
        let email = customRegister.emailTextField.text ?? ""
        let password = customRegister.passwordTextField.text ?? ""
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let result = authResult, error == nil else {
                print("Error bas verdi")
                return
            }           
            self.addFirebase()
        }
    }
    
    func addFirebase() {
        let email = customRegister.emailTextField.text ?? ""
        let password = customRegister.passwordTextField.text ?? ""
        
        let myDictionary: [String: Any] = [email: password]
        
        database.collection("Users").addDocument(data: myDictionary)
    }
}

extension RegisterScreenController: RegisterDelegate {
    func goToController() {
        
    }
}
