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
    
//    var messageAlignment: NSTextAlignment = .left {
//        didSet {
//            messageLabel. = messageAlignment
//            
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        catImage.layer.cornerRadius = 16
        catImage.clipsToBounds = true
    }
    
   
    // Initialization code
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

