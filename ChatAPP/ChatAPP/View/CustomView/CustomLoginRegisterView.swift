//
//  CustomLoginRegisterView.swift
//  ChatAPP
//
//  Created by Nazrin on 17.04.24.
//

import UIKit

protocol RegisterDelegate {
    func goToController()
    func pushBack()
}

class CustomLoginRegisterView: UIView {
    
    @IBOutlet weak var loginRegisterButton: UIButton!
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
        delegate?.goToController()
        delegate?.pushBack()
    }
}
