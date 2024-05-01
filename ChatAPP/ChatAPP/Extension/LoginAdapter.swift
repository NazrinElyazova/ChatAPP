//
//  LoginAdapter.swift
//  ChatAPP
//
//  Created by Nazrin on 30.04.24.
//

import Foundation
import GoogleSignIn

class LoginAdapter {
    var controller: UIViewController
    
    var success: ((Users)-> Void)?
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    func googleSign() {
        GIDSignIn.sharedInstance.signIn(withPresenting: controller) { result, error in
            if let error = error {
                print(error)
            }
            else if let result = result {
                let user = Users(email: result.user.profile?.email ?? "", password: "111111", name: result.user.profile?.familyName ?? "")
                self.success?(user)
            }
        }
    }
    
}
