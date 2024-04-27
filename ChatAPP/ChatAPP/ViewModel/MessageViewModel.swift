//
//  MessageViewModel.swift
//  ChatAPP
//
//  Created by Nazrin on 24.04.24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import Combine

class MessageViewModel {
    var messages = [ChatMessage]()
    var firestoreListener: ListenerRegistration?
    var cancellables = Set<AnyCancellable>()
    var onSuccess: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
    
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        onSuccess
            .sink {_ in
            }
            .store(in: &cancellables)
    }
    
    func observeMessages() {
        let database = Firestore.firestore()

        let query = database.collection("Chats").document("email1_email2").collection("messages").order(by: "timestamp")
        firestoreListener = query.addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let self else {return}
            guard let snapshot = querySnapshot else {
                print("Error: \(error!)")
                return
            }
            messages = snapshot.documents.compactMap { document -> ChatMessage? in
                let data = document.data()
                guard let sender = data["sender"] as? String,
                      let message = data["message"] as? String,
                      let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() else {
                    return nil
                }
                let photo = data["photo"] as? String ?? ""
                return ChatMessage(sender: sender, message: message, timestamp: timestamp, photo: photo)
            }
            self.onSuccess.send()
        }
    }
}
