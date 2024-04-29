//
//  MessageController.swift
//  ChatAPP

//  Created by Nazrin on 18.04.24.

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import SDWebImage
import Combine

class MessageController: UIViewController, UITextViewDelegate {
    
    let database = Firestore.firestore()
    var currentUserEmail: String?
    var selectedUserEmail: String?
    var model = MessageViewModel()
    var initialTextViewHeight: CGFloat = 60.0
    private let cache = NSCache<NSString, UIImage>()
    
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var generalView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        hideKeyboardWhenTappedAround()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            bottomCons.constant = keyboardHeight
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomCons.constant = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureViewModel()
        model.observeMessages()
        currentUserEmail = selectedUserEmail
        addObserver()
        fetchImage()
    }
    
    func configureViewModel() {
        model.onSuccess = PassthroughSubject<Void, Never>()
        model.onSuccess
            .sink { [weak self] in
                self?.table.reloadData()
            }
            .store(in: &model.cancellables)
    }
    
    func fetchImage() {
        if let image = cache.object(forKey: "image") {
            print("nil deyil \(image)")
        }
    }
    //MARK: UITEXTVIEW DELEGATE
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type a message" {
            textView.text = ""
            textView.textColor = UIColor.black
            textView.font = UIFont(name: "roboto", size: 16)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        let textSize : CGFloat = 60
        textViewHeight.constant = textSize
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let sizeToFitIn = CGSize(width: textView.bounds.width, height: CGFloat(MAXFLOAT))
        let newSize = textView.sizeThatFits(sizeToFitIn)
        textViewHeight.constant = newSize.height
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func configUI() {
        table.register(UINib(nibName: "\(MessageCell.self)", bundle: nil), forCellReuseIdentifier: "\(MessageCell.self)")
        table.separatorStyle = .none
        sendButton.clipsToBounds = true
        sendButton.layer.cornerRadius = sendButton.frame.size.height / 2
        messageTextView.delegate = self
        messageTextView.layer.borderWidth = 1
        messageTextView.layer.borderColor = UIColor.lightGray.cgColor
        messageTextView.layer.cornerRadius = 16
        initialTextViewHeight = textViewHeight.constant
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        guard let messageText = messageTextView.text, !messageText.isEmpty else {return}
        
        var photo: String?
        if currentUserEmail == "taylor@mail.ru" {
            photo = "taylor.png"
        } else if currentUserEmail == "alex@mail.ru" {
            photo = "cat.png"
        }
        
        let image = UIImage(named: photo ?? "")
        if let image = image {
            print("cache used")
            self.cache.setObject(image, forKey: "image")
        }
        
        let messageData: [String: Any] = [
            "sender": currentUserEmail!,
            "message": messageText,
            "timestamp": Date(),
            "photo": photo ?? ""
        ]
        
        if let timestamp = messageData["timestamp"] as? Date,
           let photo = messageData["photo"] as? String {
            
            let newMessage = ChatMessage(sender: currentUserEmail!, message: messageText, timestamp: timestamp, photo: photo)
            self.model.messages.append(newMessage)
            self.table.reloadData()
        }
        
        database.collection("Chats").document("email1_email2").collection("messages").addDocument(data: messageData) { error in
            if let error = error {
                print(error)
            } else {
                print("Message sent successfully")
                self.messageTextView.text = ""
                self.textViewHeight.constant = self.initialTextViewHeight
            }
        }
        
    }
}

extension MessageController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        let message = model.messages[indexPath.row]
        cell.messageLabel.text = message.message
        cell.nameLabel.text = message.sender
        cell.timeLabel.text = formatTimestamp(message.timestamp)
        cell.catImage.image = nil
        
        let img = message.photo
        Storage.storage().reference().child(img).downloadURL { url, error in
            guard let url = url else { return }
            cell.catImage.sd_setImage(with: url)
        }
        
        if message.sender == currentUserEmail {
            cell.nameLabel.text = currentUserEmail
            cell.nameAndMessageView.backgroundColor = UIColor.systemGreen
            cell.messageLabel.textAlignment = .right
            cell.nameLabel.textAlignment = .right
            cell.timeLabel.textAlignment = .right
            cell.messageLabel.textColor = .white
        }
        
        else {
            cell.nameLabel.text = message.sender
            cell.nameAndMessageView.backgroundColor = UIColor.systemGray5
            cell.messageLabel.textColor = .black
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
            let messageToRemove = model.messages[indexPath.row]
            if messageToRemove.sender == currentUserEmail || messageToRemove.sender != currentUserEmail {
                let content = messageToRemove.message
                deleteMessages(withContent: content)
                
                self.model.messages.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let message = model.messages[indexPath.row].message
//        let maxWidth = tableView.bounds.width - 32
//        let maxHeight = CGFloat.greatestFiniteMagnitude
//        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
//        let estimatedFrame = NSString(string: message).boundingRect(with: CGSize(width: maxWidth, height: maxHeight), options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
//        return min(estimatedFrame.height + 80, tableView.bounds.height - 8)
//    }
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
