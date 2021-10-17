//
//  Label.swift
//  OnTheMap
//
//  Created by Luis Alberto Rosas Arce on 10/10/21.
//

import Foundation
import UIKit

extension UIButton {
    func configureAsLink(linkText: String) {
        let titleText = titleLabel?.text ?? ""
        let mutableString = NSMutableString(string: titleText)
        let attributedString = NSMutableAttributedString(string: titleText)
        let range: NSRange = mutableString.range(of: linkText, options: .caseInsensitive)
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: .init(location: 0, length: mutableString.length))
        attributedString.addAttribute(.foregroundColor, value: UIColor.primaryColor, range: range)
        setAttributedTitle(attributedString, for: .normal)
    }
    
    func addCornerRadius() {
        layer.cornerRadius = 4.0
    }
    
    func addPrimaryStyle() {
        setTitleColor(UIColor.white, for: .normal)
        backgroundColor = UIColor.primaryColor
        
        addCornerRadius()
    }
}
