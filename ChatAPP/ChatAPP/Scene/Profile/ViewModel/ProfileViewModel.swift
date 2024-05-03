//
//  ProfileViewModel.swift
//  ChatAPP
//
//  Created by Nazrin on 03.05.24.
//

import Foundation
import UIKit

class ProfileViewModel {
    let data = [Section(section: ["Dark Mode", "Light Mode"], title: "Mode", image: UIImage(named: "light")!),
                
                Section(section: ["User info", "Data", "Active Status"], title: "Profile", image: UIImage(named: "dark")!),
                
                Section(section: ["Privacy"], title: "Preference", image: UIImage(named: "privacy")!)]
    
}
