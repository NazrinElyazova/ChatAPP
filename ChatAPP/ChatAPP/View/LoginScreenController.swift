//
//  LoginScreenController.swift
//  ChatAPP
//
//  Created by Nazrin on 17.04.24.
//

import UIKit

class LoginScreenController: UIViewController {
    @IBOutlet weak var customView: CustomLoginRegisterView! {
        
        didSet {
            customView.loginRegisterButton.setTitle("Login", for: .normal)

            customView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
extension LoginScreenController: RegisterDelegate {
    func pushBack() {
    }
    
    func goToController() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "\(RegisterScreenController.self)") as! RegisterScreenController
        navigationController?.show(controller, sender: nil)
    }
}
