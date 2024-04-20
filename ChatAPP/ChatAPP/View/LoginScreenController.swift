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
    let database = Firestore.firestore()

    @IBOutlet weak var customView: CustomLoginRegisterView! {
        
        didSet {
           configureUIElements()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Login"
    }
    
    @IBAction func registerBarButtonItem(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "\(RegisterScreenController.self)") as! RegisterScreenController
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        login()
        checkUserDefaults()
    }
    
    func configureUIElements() {
        customView.doUISettings()
        customView.emailTextField.delegate = self
        customView.passwordTextField.delegate = self

    }
    
    func checkUserDefaults() {
        UserDefaults.standard.setValue(true, forKey: "loggedIn")
    }
    
    func login() {
        FirebaseAuth.Auth.auth().signIn(withEmail: customView.emailTextField.text ?? "", password: customView.passwordTextField.text ?? "") { authResult, error in
            guard let result = authResult, error == nil else {
                print("Login ugursuz oldu")
                self.alert()
                return
            }
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "\(UsersListController.self)") as! UsersListController
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func alert() {
        let alertController = UIAlertController(title: "Warning", message: "Your info is not true", preferredStyle: .actionSheet)
        
        let tryAgainButton = UIAlertAction(title: "Try again", style: .cancel)
        
        alertController.addAction(tryAgainButton)
        present(alertController, animated: true)
        
    }
}

