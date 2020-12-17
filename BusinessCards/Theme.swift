//
//  Theme.swift
//  BusinessCards
//
//  Created by Douglas Webster on 12/11/20.
//

import Foundation
import UIKit

public class Theme {
    
    public static let backgroundColor: UIColor = {
        if #available(iOS 13, *) {
            return UIColor.systemBackground
        } else {
            return UIColor.white
        }
    }()
    
    public static var keyColor: UIColor = {
        let standardKeyColor = UIColor(red: 0/255, green: 99/255, blue: 93/255, alpha: 1)
        if #available(iOS 13, *) {
            return UIColor { (traitCollection) -> UIColor in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return UIColor(red: 0/255, green: 99/255, blue: 93/255, alpha: 1)
                case .light: fallthrough
                case .unspecified: fallthrough
                @unknown default:
                return standardKeyColor
                }
            }
        } else {
            return standardKeyColor
        }
    }()
    
    public static func getBoldLabel(text: String) -> UILabel {
        let label = UILabel()
        if #available(iOS 13, *) {
            label.textColor = UIColor.label
        }
        label.text = text
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }
    
    public static func getButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle(title, for: .normal)
        
        button.imageView?.contentMode = .scaleAspectFit
        
        button.layer.cornerRadius = 4
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
        button.clipsToBounds = true
        return button
    }
    
    public static func getTextField(placeholder: String) -> UITextField {
        let textField = PaddingTextField()
        textField.borderStyle = .roundedRect
        textField.contentVerticalAlignment = .center
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.adjustsFontForContentSizeCategory = true
        if #available(iOS 13, *) {
            textField.backgroundColor = UIColor.secondarySystemBackground
        } else {
            textField.backgroundColor = UIColor(red: 248/256, green: 248/256, blue: 248/256, alpha: 1)
        }
        textField.placeholder = placeholder
        return textField
    }
    
}
