//
//  ChatMessage.swift
//  ChatAPP
//
//  Created by Nazrin on 22.04.24.
//

import Foundation

struct ChatMessage: Codable {
    let sender: String
    let message: String
    let timestamp: Date
}


struct Users: Codable {
    var email: String
    var password: String
    var name: String
}
