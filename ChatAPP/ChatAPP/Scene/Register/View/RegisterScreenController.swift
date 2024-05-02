//
//  RegisterScreenController.swift
//  ChatAPP
//
//  Created by Nazrin on 17.04.24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreInternal
import AuthenticationServices

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
    
    func tappedAppleButton() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.email, .fullName]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    @IBAction func signApple(_ sender: Any) {
        tappedAppleButton()
    }
    
    @IBAction func googleSignButtonAction(_ sender: Any) {
        adapter?.login(type: .google)
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

extension RegisterScreenController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            let firstName = credentials.fullName?.givenName
            let lastName = credentials.fullName?.familyName
            let email = credentials.email
            break
        default:
            break
        }
    }
}

extension RegisterScreenController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
