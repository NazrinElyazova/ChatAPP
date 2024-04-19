//
//  MessageController.swift
//  ChatAPP
//
//  Created by Nazrin on 18.04.24.
//

import UIKit
import FirebaseFirestoreInternal

struct Chats: Codable {
    let sender: String
    let message: String
    let receiver: String
}

class MessageController: UIViewController {
    
    let database = Firestore.firestore()
    var model = [Chats]()
    var selectedUserEmail: String?

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var generalView: UIView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var typeMessageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getMessages()

    }
    
    func getMessages() {
        model.removeAll()
        database.collection("Chats").getDocuments { snapshot, error in
            for document in snapshot?.documents ?? [] {
                let dict = document.data()
                if let data = try? JSONSerialization.data(withJSONObject: dict) {
                    do {
                        let item = try JSONDecoder().decode(Chats.self, from: data)
                        self.model.append(item)
                    } catch {
                        print("Xeta bas verdi: \(error)")
                    }
                    self.table.reloadData()
                }
            }
        }
    }
    
    func configureUI() {
        textFieldView.layer.cornerRadius = 20
        textFieldView.clipsToBounds = true
        sendButton.layer.cornerRadius = 16
        sendButton.clipsToBounds = true
        table.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        guard let messageText = typeMessageTextField.text, !messageText.isEmpty else {
            return
        }
        
        let chat = Chats(sender: "", message: messageText, receiver: "")
        
        database.collection("Chats").addDocument(data: [
            "sender": chat.sender,
            "receiver": chat.receiver,
            "message": chat.message
        ]) { error in
            if let error = error {
                print("Xeta bas verdi: \(error)")
            } else {
                print("Mesaj gönderildi")
                self.typeMessageTextField.text = ""
                
            }
        }
    }
}
extension MessageController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(MessageCell.self)", for: indexPath) as! MessageCell
        let message = model[indexPath.row]
        cell.nameLabel.text = selectedUserEmail
        cell.messageLabel.text = message.message
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
