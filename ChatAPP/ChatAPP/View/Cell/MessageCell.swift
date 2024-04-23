//
//  MessageCell.swift
//  ChatAPP
//
//  Created by Nazrin on 18.04.24.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameAndMessageView: UIView!
    @IBOutlet weak var catImage: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        catImage.layer.cornerRadius = 18
        catImage.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

