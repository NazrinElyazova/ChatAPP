//
//  UsersListController.swift
//  ChatAPP
//
//  Created by Nazrin on 18.04.24.
//

import UIKit
import FirebaseFirestoreInternal


struct Users: Codable {
    let email: String
}

class UsersListController: UIViewController {
    var model = [Users]()
    let database = Firestore.firestore()

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUsers()
    }
    func getUsers() {
        database.collection("Users").getDocuments { snapshot, error in
            
            for document in snapshot?.documents ?? [] {
                let dict = document.data()
                
                    if let data = try? JSONSerialization.data(withJSONObject: dict) {
                        guard let item = try? JSONDecoder().decode(Users.self, from: data) else { return }
                        self.model.append(item)

                }
              
            }
            self.table.reloadData()
        }
    }
}
extension UsersListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(model.count)
        return model.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UserCell.self)", for: indexPath) as! UserCell
        cell.textLabel?.text = model[indexPath.row].email
        return cell
    }
}
