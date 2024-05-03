//
//  ProfileController.swift
//  ChatAPP
//
//  Created by Nazrin on 02.05.24.
//

import UIKit

class ProfileController: UIViewController {
    var model = ProfileViewModel()
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    func config() {
        table.register(UINib(nibName: "\(ProfileCell.self)", bundle: nil), forCellReuseIdentifier: "\(ProfileCell.self)")
        table.delegate = self
        table.dataSource = self
        
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = 60
    }
}

extension ProfileController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.data[section].section.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ProfileCell.self)", for: indexPath) as! ProfileCell
        let item = model.data[indexPath.section].section[indexPath.row]
        cell.firstLabel.text = item
        cell.profileImage.image = model.data[indexPath.section].image
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.data[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "\(ModeController.self)") as! ModeController
        navigationController?.pushViewController(controller, animated: true)
    }
}
