//
//  LoginScreenController.swift
//  ChatAPP
//
//  Created by Nazrin on 17.04.24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreInternal

class LoginScreenController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var customView: CustomLoginRegisterView! {
        
        didSet {
           configureUIElements()
        }
    }
    let database = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserDefaults()
        navigationItem.title = "Login"
    }
    
    @IBAction func registerBarButtonItem(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "\(RegisterScreenController.self)") as! RegisterScreenController
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func configureUIElements() {
        customView.doUISettings()
//        customView.delegate = self
        customView.emailTextField.delegate = self
        customView.passwordTextField.delegate = self

    }
    @IBAction func loginAction(_ sender: Any) {
        login()
    }
    
    func checkUserDefaults() {
        UserDefaults.standard.setValue(true, forKey: "loggedIn")
        
    }
    
    func login() {
        FirebaseAuth.Auth.auth().signIn(withEmail: customView.emailTextField.text ?? "", password: customView.passwordTextField.text ?? "") { authResult, error in
            guard let result = authResult, error == nil else {
                print("Login ugursuz oldu")
                return
            }
            let user = result.user
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "\(UsersListController.self)") as! UsersListController
            self.navigationController?.pushViewController(controller, animated: true)
            print("Logged in:\(user)")
        }
    }
}

