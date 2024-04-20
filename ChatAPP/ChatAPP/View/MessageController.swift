////
////  MessageController.swift
////  ChatAPP
////
////  Created by Nazrin on 18.04.24.
////
//
//import UIKit
//import FirebaseFirestoreInternal
//import Combine
//import Firebase
//
//struct Chats: Codable {
//    let sender: String
//    let message: String
//    let receiver: String
//}
//
//class MessageController: UIViewController {
//    var contr = UsersListController()
//    
//    var chatText = ""
//    var errorMessage = ""
//    
//    let database = Firestore.firestore()
//    var model = [Chats]()
//    var selectedUserEmail: String?
//    var cancellables = Set<AnyCancellable>()
//
////    textFieldBottomConstaint.constant = 400
////    textFieldBottomConstaint.constant = 20
//
//    @IBOutlet weak var sendButton: UIButton!
//    @IBOutlet weak var textFieldView: UIView!
//    @IBOutlet weak var table: UITableView!
//    @IBOutlet weak var typeMessageTextField: UITextField!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureUI()
//        table.separatorStyle = .none
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.getMessages()
////setupSnapshotListener()
//    }
//    
//    func getMessages() {
////        model.removeAll()
////        let id : String = "email1_email2"
////        database.collection("Chats").document(id).collection("chatRoomId").addSnapshotListener { snapshot, error in
////            guard let documents = snapshot?.documents else {
////                return
////            }
//////            self.model = documents.compactMap { Chats in
//////
//////                do {
//////                    
//////                }
//////                
//////            }
////        }
//////        database
//////            .collection("Chats")
//////            .addSnapshotListener { [weak self] snapshot, err in
//////                guard let self else {return}
//////                guard let documents = snapshot?.documents else {
//////                
//////                }
//////                
//////            }
//    ///
//    ///
//    ///
//        database.collection("Chats").getDocuments { snapshot, error in
//            for document in snapshot?.documents ?? [] {
//                let dict = document.data()
//                if let data = try? JSONSerialization.data(withJSONObject: dict) {
//                    do {
//                        let item = try JSONDecoder().decode(Chats.self, from: data)
//                        self.model.append(item)
//                    } catch {
//                        print("Xeta bas verdi: \(error)")
//                    }
//                    self.table.reloadData()
//                }
//            }
//        }
//    }
//  
//    
//    
////    func setupSnapshotListener() {
////        let id: String = "email1_email2"
////        let query = database.collection("Chats").document(id).collection("chatRoomId")
////        
////        query
////            .addSnapshotListener { snapshot, error in
////                if let error = error {
////                    print("Xeta bas verdi: \(error)")
////                    return
////                }
////                
////                guard let snapshot = snapshot else {
////                    print("Snapshot bulunamadı")
////                    return
////                }
////                
////                self.model.removeAll()
////                for document in snapshot.documents {
////                    let dict = document.data()
////                    if let data = try? JSONSerialization.data(withJSONObject: dict) {
////                        do {
////                            let item = try JSONDecoder().decode(Chats.self, from: data)
////                            self.model.append(item)
////                        } catch {
////                            print("Xeta bas verdi: \(error)")
////                        }
////                    }
////                }
////                self.table.reloadData()
////            }
////    }
//
//
//    
//    func configureUI() {
//        textFieldView.layer.cornerRadius = 20
//        textFieldView.clipsToBounds = true
//        sendButton.layer.cornerRadius = 16
//        sendButton.clipsToBounds = true
//        table.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
//    }
//    
//    @IBAction func sendButtonAction(_ sender: Any) {
//        guard let messageText = typeMessageTextField.text, !messageText.isEmpty else {
//            return
//        }
//        
//        let chat = Chats(sender: "", message: messageText, receiver: "")
//        
//        database.collection("Chats").addDocument(data: [
//            "sender": chat.sender,
//            "receiver": chat.receiver,
//            "message": chat.message
//        ]) { error in
//            if let error = error {
//                print("Xeta bas verdi: \(error)")
//            } else {
//                print("Mesaj gönderildi")
//                self.typeMessageTextField.text = ""
//                self.getMessages()
////                    self.setupSnapshotListener()
//            }
//        }
//    }
//}
//
//extension MessageController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return model.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "\(MessageCell.self)", for: indexPath) as! MessageCell
//        let message = model[indexPath.row]
//        cell.nameLabel.text = selectedUserEmail
//        cell.messageLabel.text = message.message
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//}
import UIKit
import Combine
import FirebaseFirestore
import FirebaseAuth

struct ChatMessage: Codable {
    let sender: String
    let message: String
    let receiver: String
}

class MessageController: UIViewController {
    var selectedUserEmail: String?
    var model = [ChatMessage]()
    var cancellables = Set<AnyCancellable>()
    
    let database = Firestore.firestore()
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var typeMessageTextField: UITextField!
    @IBOutlet weak var generalView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        table.separatorStyle = .none
        setupSnapshotListener()
    }
    
    func configureUI() {
        textFieldView.layer.cornerRadius = 20
        sendButton.layer.cornerRadius = 16
        table.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
    }
    
    func setupSnapshotListener() {
        guard let userEmail = selectedUserEmail else {
            return
        }
        
        database.collection("Chats")
            .whereField("sender", in: [Auth.auth().currentUser?.email ?? ""])
            .whereField("receiver", in: [userEmail])
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                
                self.model.removeAll()
                for document in documents {
                    let data = document.data()
                    if let jsonData = try? JSONSerialization.data(withJSONObject: data) {
                        do {
                            let chatMessage = try JSONDecoder().decode(ChatMessage.self, from: jsonData)
                            self.model.append(chatMessage)
                        } catch {
                            print("Error decoding chat message: \(error)")
                        }
                    }
                }
                
                self.table.reloadData()
            }
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        guard let messageText = typeMessageTextField.text, !messageText.isEmpty else {
            return
        }
        
        guard let receiverEmail = selectedUserEmail else {
            print("Receiver email is nil.")
            return
        }
        
        let senderEmail = Auth.auth().currentUser?.email ?? ""
        
        let chatMessage = ChatMessage(sender: senderEmail, message: messageText, receiver: receiverEmail)
        
        database.collection("Chats").addDocument(data: [
            "sender": chatMessage.sender,
            "receiver": chatMessage.receiver,
            "message": chatMessage.message
        ]) { error in
            if let error = error {
                print("Error sending message: \(error)")
            } else {
                print("Message sent successfully")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        let message = model[indexPath.row]
        cell.nameLabel.text = message.sender
        cell.messageLabel.text = message.message
        return cell
    }
}

