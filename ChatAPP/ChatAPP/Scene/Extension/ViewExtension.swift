//
//  ViewExtension.swift
//  ChatAPP
//
//  Created by Nazrin on 17.04.24.
//

import Foundation
import UIKit

extension UIView {
     func loadFromNib(nibName: String) -> UIView? {
    let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}

extension UIImage {
    func resizedImage(to size: CGSize) -> UIImage? {
        let scale = UIScreen.main.scale
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}


