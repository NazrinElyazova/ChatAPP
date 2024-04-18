//
//  CustomLoginRegisterView.swift
//  ChatAPP
//
//  Created by Nazrin on 17.04.24.
//

import UIKit
import FirebaseAuth

protocol RegisterDelegate {
    func goToController()
}

class CustomLoginRegisterView: UIView {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var delegate: RegisterDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    private func configureView() {
        guard let view = self.loadFromNib(nibName: "CustomLoginRegisterView") else {return}
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    @IBAction func logRegAction(_ sender: Any) {
        //        delegate?.goToController()
        //        checkTheUser()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func checkTheUser() {
        
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let result = authResult, error == nil else {
                print("Error bas verdi")
                return
            }
            let user = result.user
            print("Created User: \(user)")
        }
    }
    
    func doUISettings() {
        emailTextField.layer.borderColor = UIColor.purple.cgColor
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.cornerRadius = 12
        
        passwordTextField.layer.borderColor = UIColor.purple.cgColor
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.cornerRadius = 12
    }
}

extension CustomLoginRegisterView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        return true
    }
}
