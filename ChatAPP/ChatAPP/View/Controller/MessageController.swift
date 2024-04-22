//
//  MessageController.swift
//  ChatAPP

//  Created by Nazrin on 18.04.24.

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MessageController: UIViewController {
    let database = Firestore.firestore()
    var bottomConstraint: NSLayoutConstraint?
    
    var currentUserEmail: String?
    var messages = [ChatMessage]()
    var firestoreListener: ListenerRegistration?
    var selectedUserEmail: String?
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var typeMessageTextField: UITextField!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var generalView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        bottomConstraint = NSLayoutConstraint(item: generalView!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -10)
        currentUserEmail = selectedUserEmail
    }
    
    @objc func handleKeyboardNotification(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                print(keyboardFrame)
                bottomConstraint?.constant = -keyboardFrame.height
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeMessages()
    }
    
    func configUI() {
        table.register(UINib(nibName: "\(MessageCell.self)", bundle: nil), forCellReuseIdentifier: "\(MessageCell.self)")
        table.separatorStyle = .none
    }
    
    func observeMessages() {
        let query = database.collection("Chats").document("email1_email2").collection("messages").order(by: "timestamp")
        firestoreListener = query.addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshot: \(error!)")
                return
            }
            self?.messages = snapshot.documents.compactMap { document -> ChatMessage? in
                let data = document.data()
                guard let sender = data["sender"] as? String,
                      let message = data["message"] as? String,
                      let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() else {
                    return nil
                }
                return ChatMessage(sender: sender, message: message, timestamp: timestamp)
            }
            self?.table.reloadData()
        }
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        guard let messageText = typeMessageTextField.text, !messageText.isEmpty else {
            return
        }
        
        guard let currentUserEmail = currentUserEmail else {
            print("Email nildir")
            return
        }
        
        let messageData: [String: Any] = [
            "sender": currentUserEmail,
            "message": messageText,
            "timestamp": Date()
        ]
        
        if let timestamp = messageData["timestamp"] as? Date {
            let newMessage = ChatMessage(sender: currentUserEmail, message: messageText, timestamp: timestamp)
            self.messages.append(newMessage)
            self.table.reloadData()
        }
        
        database.collection("Chats").document("email1_email2").collection("messages").addDocument(data: messageData) { error in
            if let error = error {
                print(error)
            } else {
                print("Message sent successfully")
                self.typeMessageTextField.text = ""
            }
        }
    }
}

extension MessageController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        cell.messageLabel.text = message.message
        cell.nameLabel.text = message.sender
        cell.timeLabel.text = formatTimestamp(message.timestamp)
        
        if message.sender == currentUserEmail {
            cell.nameLabel.text = currentUserEmail
            cell.nameAndMessageView.backgroundColor = UIColor.systemGreen
            cell.messageLabel.textAlignment = .right
            cell.nameLabel.textAlignment = .right
            cell.timeLabel.textAlignment = .right
            //            cell.catImage.isHidden = true
            cell.messageLabel.textColor = .white
            cell.catImage.isHidden = false
            cell.catImage.image = UIImage(named: "cat")
            
            cell.catImage.frame.origin = CGPoint(x: cell.contentView.frame.width - cell.catImage.frame.width, y: cell.contentView.frame.height - cell.catImage.frame.height)
            
            
        } else {
            cell.nameLabel.text = message.sender
            cell.messageLabel.textAlignment = .left
            cell.nameLabel.textAlignment = .left
            cell.timeLabel.textAlignment = .left
            cell.catImage.isHidden = false
            cell.nameAndMessageView.backgroundColor = UIColor.systemGray5
            cell.messageLabel.textColor = .black
            cell.catImage.image = UIImage(named: "taylor")
            
            cell.catImage.frame.origin = CGPoint(x: 0, y: cell.contentView.frame.height - cell.catImage.frame.height)
            
        }
        return cell
    }
    
    func formatTimestamp(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func deleteMessages(withContent content: String) {
        let query = database.collection("Chats").document("email1_email2").collection("messages").whereField("message", isEqualTo: content)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error)
            } else {
                for document in querySnapshot!.documents {
                    let messageId = document.documentID
                    let messageRef = self.database.collection("Chats").document("email1_email2").collection("messages").document(messageId)
                    messageRef.delete { error in
                        if let error = error {
                            print(error)
                        } else {
                            print("Message removed successfully")
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let messageToRemove = messages[indexPath.row]
            guard let currentUserEmail = currentUserEmail else {
                print("Error: Email nildir")
                return
            }
            
            if messageToRemove.sender == currentUserEmail {
                let content = messageToRemove.message
                deleteMessages(withContent: content)
                
                self.messages.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                print("Ancaq öz mesajlarınızı sile bilersiz")
            }
        }
    }
}

extension MessageController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(MessageController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}