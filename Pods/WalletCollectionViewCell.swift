//
//  WalletTableViewCell.swift
//  BusinessCards
//
//  Created by Douglas Webster on 7/31/21.
//

import Foundation
import UIKit

class WalletTableViewCell: UICollectionViewCell {
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(frame: .zero)
        contentView.addSubview(containerView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(positionNameLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(phoneNumberLabel)
        contentView.addSubview(faxLabel)
        contentView.addSubview(websiteLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(companyLabel)
        contentView.addSubview(companyLogo)
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var cachedFirstName: String = ""
    private var cachedLastName: String = ""
    
    var firstName: String {
        get {
            return cachedFirstName.trimWhitespace()
        }
        set {
            cachedFirstName = newValue
            nameLabel.text = name
        }
    }
    
    var lastName: String {
        get {
            return cachedLastName.trimWhitespace()
        }
        set {
            cachedLastName = newValue
            nameLabel.text = name
        }
    }
    
    var name: String {
        let newValue: String
        if firstName.isBlank && lastName.isBlank {
            newValue = ""
        } else if firstName.isBlank {
            newValue = lastName
        } else if lastName.isBlank {
            newValue = firstName
        } else {
            newValue = firstName + " " + lastName
        }
        return newValue
    }
    
    var companyName: String {
        get {
            return (companyLabel.text ?? "").trimWhitespace()
        }
        set {
            companyLabel.text = newValue
        }
    }
    
    var positionName: String {
        get {
            return (positionNameLabel.text ?? "").trimWhitespace()
        }
        set {
            positionNameLabel.text = newValue
        }
    }
    
    var email: String {
        get {
            return (emailLabel.text ?? "").trimWhitespace()
        }
        set {
            emailLabel.text = newValue
        }
    }
    
    var phoneNumber: String {
        get {
            return (phoneNumberLabel.text ?? "").trimWhitespace()
        }
        set {
            phoneNumberLabel.text = newValue
        }
    }
    
    var fax: String {
        get {
            return (faxLabel.text ?? "").trimWhitespace()
        }
        set {
            faxLabel.text = newValue
        }
    }
    
    var website: String {
        get {
            return (websiteLabel.text ?? "").trimWhitespace()
        }
        set {
            websiteLabel.text = newValue
        }
    }
    
    var address: String {
        get {
            return (addressLabel.text ?? "").trimWhitespace()
        }
        set {
            addressLabel.text = newValue
        }
    }
    
    var image: UIImageView {
        get {
            return companyLogo
        }
        set {
            companyLogo = newValue
            contentView.addSubview(companyLogo)
        }
    }
    
    public static func preferredRowHeight() -> CGFloat {
        return 450
    }
    
    private let padding: CGFloat = 12
    override func layoutSubviews() {
        super.layoutSubviews()
        let insets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        var availableBounds = contentView.bounds.inset(by: insets)
        
        containerView.frame = availableBounds
                
        var nameLabelFrame = CGRect.zero
        nameLabelFrame.origin.x = availableBounds.minX
        nameLabelFrame.origin.y = availableBounds.minY
        nameLabelFrame.size = nameLabel.intrinsicContentSize
        nameLabel.frame = nameLabelFrame
        
        let nameLabelOffset = nameLabelFrame.height + padding
        availableBounds.origin.y += nameLabelOffset
        availableBounds.size.height -= nameLabelOffset
        
        var positionNameLabelFrame = CGRect.zero
        positionNameLabelFrame.origin.x = availableBounds.minX
        positionNameLabelFrame.origin.y = availableBounds.minY
        positionNameLabelFrame.size = positionNameLabel.intrinsicContentSize
        positionNameLabel.frame = positionNameLabelFrame
        
        let positionNameLabelOffest = positionNameLabelFrame.height + padding
        availableBounds.origin.y += positionNameLabelOffest
        availableBounds.size.height -= positionNameLabelOffest
        
        var addressLabelFrame = CGRect.zero
        addressLabelFrame.origin.x = availableBounds.minX
        addressLabelFrame.origin.y = availableBounds.minY
        addressLabelFrame.size = addressLabel.intrinsicContentSize
        addressLabel.frame = addressLabelFrame
        
        let addressLabelOffset = addressLabelFrame.height + padding
        availableBounds.origin.y += addressLabelOffset
        availableBounds.size.height -= addressLabelOffset
        
        var phoneNumberLabelFrame = CGRect.zero
        phoneNumberLabelFrame.origin.x = availableBounds.minX
        phoneNumberLabelFrame.origin.y = availableBounds.minY
        phoneNumberLabelFrame.size = phoneNumberLabel.intrinsicContentSize
        phoneNumberLabel.frame = phoneNumberLabelFrame
        
        let phoneNumberLabelOffset = phoneNumberLabelFrame.height + padding
        availableBounds.origin.y += phoneNumberLabelOffset
        availableBounds.size.height -= phoneNumberLabelOffset
        
        var faxLabelFrame = CGRect.zero
        faxLabelFrame.origin.x = availableBounds.minX
        faxLabelFrame.origin.y = availableBounds.minY
        faxLabelFrame.size = faxLabel.intrinsicContentSize
        faxLabel.frame = faxLabelFrame
        
        let faxLabelOffset = faxLabelFrame.height + padding
        availableBounds.origin.y += faxLabelOffset
        availableBounds.size.height -= faxLabelOffset
        
        var emailLabelFrame = CGRect.zero
        emailLabelFrame.origin.x = availableBounds.minX
        emailLabelFrame.origin.y = availableBounds.minY
        emailLabelFrame.size = emailLabel.intrinsicContentSize
        emailLabel.frame = emailLabelFrame
        
        let emailLabelOffset = emailLabelFrame.height + padding
        availableBounds.origin.y += emailLabelOffset
        availableBounds.size.height -= emailLabelOffset
        
        var websiteLabelFrame = CGRect.zero
        websiteLabelFrame.origin.x = availableBounds.minX
        websiteLabelFrame.origin.y = availableBounds.minY
        websiteLabelFrame.size = websiteLabel.intrinsicContentSize
        websiteLabel.frame = websiteLabelFrame
        
        let websiteLabelOffset = websiteLabelFrame.height + padding
        availableBounds.origin.y += websiteLabelOffset
        availableBounds.size.height -= websiteLabelOffset
        
        let companyLogoSize = companyLogo.intrinsicContentSize
        var companyLogoFrame = CGRect.zero
        companyLogoFrame.origin.x = availableBounds.maxX - companyLogoSize.width
        companyLogoFrame.origin.y = availableBounds.maxY - companyLogoSize.height
        companyLogoFrame.size = companyLogoSize
        companyLogo.frame = companyLogoFrame
        
        let companyLabelSize = companyLabel.intrinsicContentSize
        var companyLabelFrame = CGRect.zero
        companyLabelFrame.origin.x = availableBounds.maxX - companyLogoFrame.width - companyLabelSize.width - padding
        companyLabelFrame.origin.y = availableBounds.maxY - companyLabelSize.height
        companyLabelFrame.size = companyLabel.intrinsicContentSize
        companyLabel.frame = companyLabelFrame
    }
    
    private lazy var nameLabel: UILabel = {
        let label = Theme.getBoldLabel(text: "")
        return label
    }()

    private lazy var companyLabel: UILabel = {
        let label = Theme.getBoldLabel(text: "")
        return label
    }()
    
    private lazy var positionNameLabel: UILabel = {
        let label = Theme.getBoldLabel(text: "")
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = Theme.getBoldLabel(text: "")
        return label
    }()
    
    private lazy var phoneNumberLabel: UILabel = {
        let label = Theme.getBoldLabel(text: "")
        return label
    }()
    
    private lazy var faxLabel: UILabel = {
        let label = Theme.getBoldLabel(text: "")
        return label
    }()
    
    private lazy var websiteLabel: UILabel = {
        let label = Theme.getBoldLabel(text: "")
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = Theme.getBoldLabel(text: "")
        return label
    }()
    
    private lazy var companyLogo: UIImageView = {
        let image = UIImageView()//(image: UIImage(systemName: "applelogo"))
        image.tintColor = .darkGray
        return image
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.secondaryColor
        view.layer.cornerRadius = 20
        return view
    }()

}
