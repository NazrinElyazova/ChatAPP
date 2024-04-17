//
//  RegisterScreenController.swift
//  ChatAPP
//
//  Created by Nazrin on 17.04.24.
//

import UIKit

class RegisterScreenController: UIViewController {

    @IBOutlet weak var customRegister: CustomLoginRegisterView! {
        didSet {
            customRegister.loginRegisterButton.setTitle("Register", for: .normal)
            customRegister.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
extension RegisterScreenController: RegisterDelegate {
    func goToController() {
        
    }
    
    func pushBack() {
        navigationController?.popViewController(animated: true)
    }
    
    
}
