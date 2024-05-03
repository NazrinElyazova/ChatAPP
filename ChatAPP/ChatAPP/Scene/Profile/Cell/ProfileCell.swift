//
//  ProfileCell.swift
//  ChatAPP
//
//  Created by Nazrin on 02.05.24.
//

import UIKit

class ProfileCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
  
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
