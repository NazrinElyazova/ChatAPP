//
//  CustomLoginRegisterView.swift
//  ChatAPP
//
//  Created by Nazrin on 17.04.24.
//

import UIKit
import FirebaseAuth

class CustomLoginRegisterView: UIView {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
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
