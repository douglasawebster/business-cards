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
        let standardKeyColor = UIColor(red: 241/256, green: 81/256, blue: 86/256, alpha: 1)
        if #available(iOS 13, *) {
            return UIColor { (traitCollection) -> UIColor in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return UIColor(red: 241/256,
                                   green: 81/256,
                                   blue: 86/256,
                                   alpha: 1.0)
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
    
}
