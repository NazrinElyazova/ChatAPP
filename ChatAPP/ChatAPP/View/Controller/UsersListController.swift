//
//  UsersListController.swift
//  ChatAPP
//
//  Created by Nazrin on 18.04.24.
//

import UIKit
import FirebaseFirestoreInternal
import FirebaseAuth

class UsersListController: UIViewController {
    var model = [Users]()
    let database = Firestore.firestore()
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
    }
    
    func getUsers() {
        model.removeAll()
        database.collection("Users").getDocuments { snapshot, error in
            for document in snapshot?.documents ?? [] {
                let dict = document.data()
                if let data = try? JSONSerialization.data(withJSONObject: dict) {
                    do {
                        let item = try JSONDecoder().decode(Users.self, from: data)
                        self.model.append(item)
                    } catch {
                        //                        print("Xeta bas verdi: \(error)")
                    }
                    self.table.reloadData()
                }
            }
        }
    }
}

extension UsersListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(model.count)
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell")
        cell?.textLabel?.text = model[indexPath.row].email
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "\(MessageController.self)") as! MessageController
        let selectedUser = model[indexPath.row]
        controller.selectedUserEmail = selectedUser.email
        navigationController?.pushViewController(controller, animated: true)
    }
}
