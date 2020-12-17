//
//  PaddingTextField.swift
//  BusinessCards
//
//  Created by Douglas Webster on 12/16/20.
//

import Foundation
import UIKit

open class PaddingTextField: UITextField {
    let verticalPadding: CGFloat = 3
    let horizontalPadding: CGFloat = 8
    
    public var showsSelectionBorder = true {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += horizontalPadding * 2
        size.height += verticalPadding * 2
        return size
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if isFirstResponder && self.showsSelectionBorder {
            self.layer.borderColor = Theme.keyColor.cgColor
            self.layer.borderWidth = 1.0
            self.layer.cornerRadius = 5.0
        } else {
            self.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    override open func becomeFirstResponder() -> Bool {
        let shouldBecomeFirstResponder = super.becomeFirstResponder()
        if shouldBecomeFirstResponder {
            self.setNeedsLayout()
        }
        return shouldBecomeFirstResponder
    }
    
    override open func resignFirstResponder() -> Bool {
        let shouldResignFirstResponder = super.resignFirstResponder()
        if shouldResignFirstResponder {
            self.setNeedsLayout()
        }
        return shouldResignFirstResponder
    }
}
