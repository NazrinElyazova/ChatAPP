//
//  RegisterScreenController.swift
//  ChatAPP
//
//  Created by Nazrin on 17.04.24.
//

import UIKit
import FirebaseAuth

class RegisterScreenController: UIViewController {
    
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
            let user = result.user
            print("Created User: \(user)")
        }
    }
}

extension RegisterScreenController: RegisterDelegate {
    func goToController() {
        
    }
}
